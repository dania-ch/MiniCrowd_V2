import Foundation

// Modèle pour les Catégories (2ème modèle de données)
struct Category: Codable, Sendable {
    let id: Int64?
    var name: String
}

// Modèle classique du projet
struct Project: Codable, Sendable {
    let id: Int64?
    var title: String
    var description: String
    var goal: Double
    var currentAmount: Double
    var categoryId: Int64
}

// Structure combinée pour la vue (Jointure SQL)
struct ProjectDetail: Codable, Sendable {
    let id: Int64
    var title: String
    var description: String
    var goal: Double
    var currentAmount: Double
    var categoryId: Int64
    var categoryName: String
}