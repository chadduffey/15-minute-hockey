import Foundation

struct Friend: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var currentStreak: Int
    var completedToday: Bool
    var completedThisWeek: Int

    init(
        id: UUID = UUID(),
        name: String,
        currentStreak: Int,
        completedToday: Bool,
        completedThisWeek: Int
    ) {
        self.id = id
        self.name = name
        self.currentStreak = currentStreak
        self.completedToday = completedToday
        self.completedThisWeek = completedThisWeek
    }
}
