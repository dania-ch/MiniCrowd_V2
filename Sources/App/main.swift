import Foundation
import Hummingbird
@preconcurrency import SQLite

let db = try Database.setup()

let router = Router()

// HOME
router.get("/") { _, _ -> HTML in
    let projects = try Database.fetchAllProjects(db: db)
    return Views.renderIndex(items: projects)
}

// ADD PROJECT
router.post("/add") { request, _ -> Response in
    let buffer = try await request.body.collect(upTo: 1024 * 16)
    let bodyString = String(buffer: buffer)

    var components = URLComponents()
    components.percentEncodedQuery = bodyString

    let title = components.queryItems?.first(where: { $0.name == "title" })?.value ?? ""
    let description = components.queryItems?.first(where: { $0.name == "description" })?.value ?? ""
    let goalStr = components.queryItems?.first(where: { $0.name == "goal" })?.value ?? "0"

    guard let goal = Double(goalStr), !title.isEmpty else {
        return Response(status: .badRequest)
    }

    try Database.addProject(db: db, title: title, description: description, goal: goal)

    return Response(status: .seeOther, headers: [.location: "/"])
}

// DELETE
router.post("/delete/:id") { _, context -> Response in
    guard let idStr = context.parameters.get("id"), let pid = Int64(idStr) else {
        return Response(status: .badRequest)
    }

    try Database.deleteProject(db: db, id: pid)

    return Response(status: .seeOther, headers: [.location: "/"])
}

// DONATE
router.post("/donate/:id") { _, context -> Response in
    guard let idStr = context.parameters.get("id"), let pid = Int64(idStr) else {
        return Response(status: .badRequest)
    }

    try Database.donate(db: db, id: pid, amount: 10)

    return Response(status: .seeOther, headers: [.location: "/"])
}

// SERVER
let app = Application(
    router: router,
    configuration: .init(address: .hostname("0.0.0.0", port: 8080))
)

print("🚀 Crowdfunding running on http://localhost:8080")

try await app.runService()