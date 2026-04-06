import SQLite
import Foundation

// Fix concurrency Swift
extension Connection: @unchecked @retroactive Sendable {}

struct Database {

    // Table
    static let projects = Table("projects")

    // Colonnes
    static let id = Expression<Int64>("id")
    static let title = Expression<String>("title")
    static let description = Expression<String>("description")
    static let goal = Expression<Double>("goal")
    static let currentAmount = Expression<Double>("currentAmount")

    // Setup DB
    static func setup() throws -> Connection {
        let db = try Connection("db.sqlite3")

        try db.run(projects.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(title)
            t.column(description)
            t.column(goal)
            t.column(currentAmount, defaultValue: 0.0)
        })

        return db
    }

    // READ ALL
    static func fetchAllProjects(db: Connection) throws -> [Project] {
        return try db.prepare(projects).map { row in
            Project(
                id: row[id],
                title: row[title],
                description: row[description],
                goal: row[goal],
                currentAmount: row[currentAmount]
            )
        }
    }

    // CREATE
    static func addProject(db: Connection, title: String, description: String, goal: Double) throws {
        let insert = projects.insert(
            self.title <- title,
            self.description <- description,
            self.goal <- goal,
            self.currentAmount <- 0.0
        )
        try db.run(insert)
    }

    // DELETE
    static func deleteProject(db: Connection, id pid: Int64) throws {
        let project = projects.filter(self.id == pid)
        try db.run(project.delete())
    }

    // DONATE
    static func donate(db: Connection, id pid: Int64, amount: Double) throws {
        let project = projects.filter(self.id == pid)

        if let p = try db.pluck(project) {
            let newAmount = p[currentAmount] + amount
            try db.run(project.update(currentAmount <- newAmount))
        }
    }
}