import Foundation

struct PracticeSkill: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var symbol: String
    var sortOrder: Int

    init(id: String = UUID().uuidString, title: String, symbol: String, sortOrder: Int) {
        self.id = id
        self.title = title
        self.symbol = symbol
        self.sortOrder = sortOrder
    }
}
