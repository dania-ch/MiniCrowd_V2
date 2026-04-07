import SQLite
import Foundation

// Fix concurrency Swift
extension Connection: @unchecked @retroactive Sendable {}

struct Database {
    // Tables
    static let projects = Table("projects")
    static let categories = Table("categories")

    // Colonnes Projects
    static let p_id = Expression<Int64>("id")
    static let p_title = Expression<String>("title")
    static let p_description = Expression<String>("description")
    static let p_goal = Expression<Double>("goal")
    static let p_currentAmount = Expression<Double>("currentAmount")
    static let p_categoryId = Expression<Int64>("category_id")

    // Colonnes Categories
    static let c_id = Expression<Int64>("id")
    static let c_name = Expression<String>("name")

    // Setup DB
    static func setup() throws -> Connection {
        let db = try Connection("db.sqlite3")

        // Table Categories
        try db.run(categories.create(ifNotExists: true) { t in
            t.column(c_id, primaryKey: .autoincrement)
            t.column(c_name, unique: true)
        })

        // Table Projects
        try db.run(projects.create(ifNotExists: true) { t in
            t.column(p_id, primaryKey: .autoincrement)
            t.column(p_title)
            t.column(p_description)
            t.column(p_goal)
            t.column(p_currentAmount, defaultValue: 0.0)
            t.column(p_categoryId, references: categories, c_id)
        })

        // Seed: Remplir les catégories si elles sont vides
        if try db.scalar(categories.count) == 0 {
            try db.run(categories.insert(c_name <- "Innovation & Tech 💻"))
            try db.run(categories.insert(c_name <- "Art & Création 🎨"))
            try db.run(categories.insert(c_name <- "Communauté 🤝"))
            try db.run(categories.insert(c_name <- "Environnement 🌍"))
        }

        return db
    }

    // Récupérer toutes les catégories
    static func fetchAllCategories(db: Connection) throws -> [Category] {
        return try db.prepare(categories).map { row in
            Category(id: row[c_id], name: row[c_name])
        }
    }

    // READ ALL avec Recherche, Tri et Filtres (Catégorie + Statut)
    static func fetchProjects(db: Connection, search: String? = nil, sort: String? = nil, categoryId: Int64? = nil, status: String? = nil) throws -> [ProjectDetail] {
        var query = projects.join(categories, on: categories[c_id] == projects[p_categoryId])

        if let search = search, !search.isEmpty {
            let pattern = "%\(search)%"
            query = query.filter(projects[p_title].like(pattern) || projects[p_description].like(pattern))
        }

        if let catId = categoryId, catId > 0 {
            query = query.filter(projects[p_categoryId] == catId)
        }

        if status == "funded" {
            query = query.filter(projects[p_currentAmount] >= projects[p_goal])
        } else if status == "ongoing" {
            query = query.filter(projects[p_currentAmount] < projects[p_goal])
        }

        switch sort {
        case "goal": query = query.order(projects[p_goal].desc)
        case "title": query = query.order(projects[p_title].asc)
        default: query = query.order(projects[p_id].desc)
        }

        return try db.prepare(query).map { row in
            ProjectDetail(id: row[projects[p_id]], title: row[projects[p_title]], description: row[projects[p_description]], goal: row[projects[p_goal]], currentAmount: row[projects[p_currentAmount]], categoryId: row[projects[p_categoryId]], categoryName: row[categories[c_name]])
        }
    }

    // GET SINGLE PROJECT (Bonus Detail Page)
    static func fetchProject(db: Connection, id targetId: Int64) throws -> ProjectDetail? {
        let query = projects.join(categories, on: categories[c_id] == projects[p_categoryId])
                            .filter(projects[p_id] == targetId)
        
        guard let row = try db.pluck(query) else { return nil }
        
        return ProjectDetail(
            id: row[projects[p_id]],
            title: row[projects[p_title]],
            description: row[projects[p_description]],
            goal: row[projects[p_goal]],
            currentAmount: row[projects[p_currentAmount]],
            categoryId: row[projects[p_categoryId]],
            categoryName: row[categories[c_name]]
        )
    }

    // CREATE
    static func addProject(db: Connection, title: String, description: String, goal: Double, categoryId: Int64) throws {
        let insert = projects.insert(
            self.p_title <- title,
            self.p_description <- description,
            self.p_goal <- goal,
            self.p_currentAmount <- 0.0,
            self.p_categoryId <- categoryId
        )
        try db.run(insert)
    }

    // UPDATE COMPLET (Bonus)
    static func updateProject(db: Connection, id pid: Int64, title: String, description: String, goal: Double, categoryId: Int64) throws {
        let project = projects.filter(self.p_id == pid)
        try db.run(project.update(
            self.p_title <- title,
            self.p_description <- description,
            self.p_goal <- goal,
            self.p_categoryId <- categoryId
        ))
    }

    // DELETE
    static func deleteProject(db: Connection, id pid: Int64) throws {
        let project = projects.filter(self.p_id == pid)
        try db.run(project.delete())
    }

    // DONATE
    static func donate(db: Connection, id pid: Int64, amount: Double) throws {
        let project = projects.filter(self.p_id == pid)
        if let p = try db.pluck(project) {
        if p[p_currentAmount] < p[p_goal] {
          let newAmount = p[p_currentAmount] + amount
          try db.run(project.update(p_currentAmount <- newAmount))
         }
        }
    }
}