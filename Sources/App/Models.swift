import Foundation

struct Project: Codable, Sendable {
    let id: Int64?
    var title: String
    var description: String
    var goal: Double
    var currentAmount: Double
}