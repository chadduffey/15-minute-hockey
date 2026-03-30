import Foundation

struct PracticeSession: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var durationMinutes: Int
    var skillIDs: Set<String>
    var note: String
    var completed: Bool

    init(
        id: UUID = UUID(),
        date: Date,
        durationMinutes: Int = 15,
        skillIDs: Set<String> = [],
        note: String = "",
        completed: Bool = true
    ) {
        self.id = id
        self.date = date
        self.durationMinutes = durationMinutes
        self.skillIDs = skillIDs
        self.note = note
        self.completed = completed
    }
}
