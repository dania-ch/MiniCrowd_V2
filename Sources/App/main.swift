import Foundation
import Hummingbird
@preconcurrency import SQLite

let db = try Database.setup()
let router = Router()

// Helper pour parser les requêtes POST x-www-form-urlencoded
func parseBody(request: Request) async throws -> [URLQueryItem] {
    let buffer = try await request.body.collect(upTo: 1024 * 16)
    let bodyString = String(buffer: buffer)
    var components = URLComponents()
    components.percentEncodedQuery = bodyString
    return components.queryItems ?? []
}

// --- ROUTES ---

// 1. HOME (Read All + Sort + Search)
router.get("/") { request, _ -> HTML in
    // Parsing des paramètres GET ?search=xxx&sort=xxx&error=xxx
    let components = URLComponents(string: request.uri.string)
    let queryItems = components?.queryItems
    let search = queryItems?.first(where: { $0.name == "search" })?.value
    let sort = queryItems?.first(where: { $0.name == "sort" })?.value
    let error = queryItems?.first(where: { $0.name == "error" })?.value

    let categories = try Database.fetchAllCategories(db: db)
    let projects = try Database.fetchProjects(db: db, search: search, sort: sort)
    
    return Views.renderIndex(items: projects, categories: categories, search: search, sort: sort, error: error)
}

// 2. DETAIL PAGE (Read One)
router.get("/project/:id") { request, context -> HTML in
    guard let idStr = context.parameters.get("id"), let pid = Int64(idStr),
          let project = try Database.fetchProject(db: db, id: pid) else {
        return Views.renderIndex(items: [], categories: [], search: nil, sort: nil, error: "Projet introuvable")
    }
    
    let components = URLComponents(string: request.uri.string)
    let error = components?.queryItems?.first(where: { $0.name == "error" })?.value
    let categories = try Database.fetchAllCategories(db: db)
    
    return Views.renderDetail(project: project, categories: categories, error: error)
}

// 3. ADD PROJECT (Create + Validation)
router.post("/add") { request, _ -> Response in
    let params = try await parseBody(request: request)
    
    let title = params.first(where: { $0.name == "title" })?.value?.trimmingCharacters(in: .whitespaces) ?? ""
    let description = params.first(where: { $0.name == "description" })?.value ?? ""
    let goalStr = params.first(where: { $0.name == "goal" })?.value ?? "0"
    let catStr = params.first(where: { $0.name == "categoryId" })?.value ?? "0"

    // VALIDATION (Bonus)
    guard let goal = Double(goalStr), goal > 0, 
          let categoryId = Int64(catStr), !title.isEmpty else {
        return Response(status: .seeOther, headers: [.location: "/?error=invalid"])
    }

    try Database.addProject(db: db, title: title, description: description, goal: goal, categoryId: categoryId)
    return Response(status: .seeOther, headers: [.location: "/"])
}

// 4. EDIT PROJECT (Update)
router.post("/project/:id/edit") { request, context -> Response in
    guard let idStr = context.parameters.get("id"), let pid = Int64(idStr) else {
        return Response(status: .badRequest)
    }
    
    let params = try await parseBody(request: request)
    let title = params.first(where: { $0.name == "title" })?.value?.trimmingCharacters(in: .whitespaces) ?? ""
    let description = params.first(where: { $0.name == "description" })?.value ?? ""
    let goalStr = params.first(where: { $0.name == "goal" })?.value ?? "0"
    let catStr = params.first(where: { $0.name == "categoryId" })?.value ?? "0"

    // VALIDATION
    guard let goal = Double(goalStr), goal > 0, 
          let categoryId = Int64(catStr), !title.isEmpty else {
        return Response(status: .seeOther, headers: [.location: "/project/\(pid)?error=invalid"])
    }

    try Database.updateProject(db: db, id: pid, title: title, description: description, goal: goal, categoryId: categoryId)
    return Response(status: .seeOther, headers: [.location: "/project/\(pid)"])
}

// 5. DELETE (Delete)
router.post("/delete/:id") { _, context -> Response in
    guard let idStr = context.parameters.get("id"), let pid = Int64(idStr) else {
        return Response(status: .badRequest)
    }
    try Database.deleteProject(db: db, id: pid)
    return Response(status: .seeOther, headers: [.location: "/"])
}

// 6. DONATE (Update partiel avec montant libre)
router.post("/donate/:id") { request, context -> Response in
    guard let idStr = context.parameters.get("id"), let pid = Int64(idStr) else {
        return Response(status: .badRequest)
    }
    
    // Récupération du montant depuis le formulaire
    let params = try await parseBody(request: request)
    let amountStr = params.first(where: { $0.name == "amount" })?.value ?? "0"
    
    // Validation du montant
    guard let amount = Double(amountStr), amount > 0 else {
        let referer = request.headers[.referer] ?? "/"
        let separator = referer.contains("?") ? "&" : "?"
        return Response(status: .seeOther, headers: [.location: "\(referer)\(separator)error=invalid_amount"])
    }

    // Ajout du don en base de données
    try Database.donate(db: db, id: pid, amount: amount)
    
    // Retour malin : on redirige vers la page d'où l'utilisateur vient
    let referer = request.headers[.referer] ?? "/"
    return Response(status: .seeOther, headers: [.location: referer])
}

// --- SERVER SETUP ---
let app = Application(
    router: router,
    configuration: .init(address: .hostname("0.0.0.0", port: 8080))
)

print("🚀 Crowdfunding running on http://localhost:8080")
try await app.runService()