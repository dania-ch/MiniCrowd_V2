import Foundation

// Modele pour les Categories (2eme modele de donnees)
struct Category: Codable, Sendable {
    let id: Int64?
    var name: String
}

// Modele classique du projet
struct Project: Codable, Sendable {
    let id: Int64?
    var title: String
    var description: String
    var goal: Double
    var currentAmount: Double
    var categoryId: Int64
}

// Structure combinee pour la vue (Jointure SQL)
struct ProjectDetail: Codable, Sendable {
    let id: Int64
    var title: String
    var description: String
    var goal: Double
    var currentAmount: Double
    var categoryId: Int64
    var categoryName: String
}
