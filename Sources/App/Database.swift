import SQLite
import Foundation

extension Connection: @unchecked @retroactive Sendable {}

struct Database {

    static let projects = Table("projects")

    static let id = Expression<Int64>("id")
    static let title = Expression<String>("title")
    static let description = Expression<String>("description")
    static let goal = Expression<Double>("goal")
    static let currentAmount = Expression<Double>("currentAmount")
    static let category = Expression<String>("category")
    static let createdAt = Expression<String>("createdAt")

    static func setup() throws -> Connection {
        let db = try Connection("db.sqlite3")

        try db.run(projects.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(title)
            t.column(description)
            t.column(goal)
            t.column(currentAmount, defaultValue: 0.0)
            t.column(category)
            t.column(createdAt)
        })

        return db
    }

    // READ ALL
    static func fetchAllProjects(db: Connection) throws -> [Project] {
        try db.prepare(projects).map {
            Project(
                id: $0[id],
                title: $0[title],
                description: $0[description],
                goal: $0[goal],
                currentAmount: $0[currentAmount],
                category: $0[category],
                createdAt: $0[createdAt]
            )
        }
    }

    // SEARCH (BONUS 🔥)
    static func searchProjects(db: Connection, keyword: String) throws -> [Project] {
        let query = projects.filter(title.like("%\(keyword)%"))
        return try db.prepare(query).map {
            Project(
                id: $0[id],
                title: $0[title],
                description: $0[description],
                goal: $0[goal],
                currentAmount: $0[currentAmount],
                category: $0[category],
                createdAt: $0[createdAt]
            )
        }
    }

    // CREATE
    static func addProject(db: Connection, title: String, description: String, goal: Double, category: String) throws {
        let date = ISO8601DateFormatter().string(from: Date())

        try db.run(projects.insert(
            self.title <- title,
            self.description <- description,
            self.goal <- goal,
            self.currentAmount <- 0.0,
            self.category <- category,
            self.createdAt <- date
        ))
    }

    // DELETE
    static func deleteProject(db: Connection, id pid: Int64) throws {
        try db.run(projects.filter(id == pid).delete())
    }

    // UPDATE (IMPORTANT 🔥)
    static func updateProject(db: Connection, id pid: Int64, title: String, description: String, goal: Double) throws {
        let project = projects.filter(id == pid)

        try db.run(project.update(
            self.title <- title,
            self.description <- description,
            self.goal <- goal
        ))
    }

    // DONATE
    static func donate(db: Connection, id pid: Int64, amount: Double) throws {
        let project = projects.filter(id == pid)

        if let p = try db.pluck(project) {
            try db.run(project.update(currentAmount <- p[currentAmount] + amount))
        }
    }

    // GET BY ID (DETAIL PAGE 🔥)
    static func getById(db: Connection, id pid: Int64) throws -> Project? {
        let project = projects.filter(id == pid)

        if let p = try db.pluck(project) {
            return Project(
                id: p[id],
                title: p[title],
                description: p[description],
                goal: p[goal],
                currentAmount: p[currentAmount],
                category: p[category],
                createdAt: p[createdAt]
            )
        }
        return nil
    }
}