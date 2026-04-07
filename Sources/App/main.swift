import Foundation
import Hummingbird
@preconcurrency import SQLite

let db = try Database.setup()
let router = Router()

// HOME + SEARCH
router.get("/") { request, _ -> HTML in
    let keyword = request.uri.query?.split(separator: "=").last ?? ""

    let projects = keyword.isEmpty
        ? try Database.fetchAllProjects(db: db)
        : try Database.searchProjects(db: db, keyword: String(keyword))

    return Views.renderIndex(items: projects)
}

// CREATE
router.post("/add") { request, _ -> Response in
    let buffer = try await request.body.collect(upTo: 1024 * 16)
    let body = String(buffer: buffer)

    var comp = URLComponents()
    comp.percentEncodedQuery = body

    let title = comp.queryItems?.first(where: {$0.name=="title"})?.value ?? ""
    let description = comp.queryItems?.first(where: {$0.name=="description"})?.value ?? ""
    let goalStr = comp.queryItems?.first(where: {$0.name=="goal"})?.value ?? "0"
    let category = comp.queryItems?.first(where: {$0.name=="category"})?.value ?? "General"

    guard let goal = Double(goalStr), !title.isEmpty else {
        return Response(status: .badRequest)
    }

    try Database.addProject(db: db, title: title, description: description, goal: goal, category: category)

    return Response(status: .seeOther, headers: [.location: "/"])
}

// DELETE
router.post("/delete/:id") { _, ctx -> Response in
    let id = Int64(ctx.parameters.get("id")!)!
    try Database.deleteProject(db: db, id: id)
    return Response(status: .seeOther, headers: [.location: "/"])
}

// DONATE
router.post("/donate/:id") { _, ctx -> Response in
    let id = Int64(ctx.parameters.get("id")!)!
    try Database.donate(db: db, id: id, amount: 10)
    return Response(status: .seeOther, headers: [.location: "/"])
}

// DETAIL PAGE (BONUS 🔥)
router.get("/project/:id") { _, ctx -> HTML in
    let id = Int64(ctx.parameters.get("id")!)!
    let project = try Database.getById(db: db, id: id)!
    return Views.renderDetail(project: project)
}

// UPDATE
router.post("/update/:id") { request, ctx -> Response in
    let id = Int64(ctx.parameters.get("id")!)!

    let buffer = try await request.body.collect(upTo: 1024 * 16)
    let body = String(buffer: buffer)

    var comp = URLComponents()
    comp.percentEncodedQuery = body

    let title = comp.queryItems?.first(where: {$0.name=="title"})?.value ?? ""
    let description = comp.queryItems?.first(where: {$0.name=="description"})?.value ?? ""
    let goal = Double(comp.queryItems?.first(where: {$0.name=="goal"})?.value ?? "0") ?? 0

    try Database.updateProject(db: db, id: id, title: title, description: description, goal: goal)

    return Response(status: .seeOther, headers: [.location: "/"])
}

let app = Application(router: router, configuration: .init(address: .hostname("0.0.0.0", port: 8080)))
print("🚀 http://localhost:8080")
try await app.runService()