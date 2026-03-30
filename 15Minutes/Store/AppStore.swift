import Foundation
import Observation
import SwiftUI
import UserNotifications

@MainActor
@Observable
final class AppStore {
    var userName: String { didSet { persistIfReady() } }
    var profileSymbol: String { didSet { persistIfReady() } }
    var profileImageData: Data? { didSet { persistIfReady() } }
    var goalTitle: String { didSet { persistIfReady() } }
    var goalDate: Date { didSet { persistIfReady() } }
    var selectedThemeID: String { didSet { persistIfReady() } }
    var skills: [PracticeSkill] { didSet { persistIfReady() } }
    var sessions: [PracticeSession] { didSet { persistIfReady() } }
    var friends: [Friend] { didSet { persistIfReady() } }
    var reminderEnabled: Bool {
        didSet {
            persistIfReady()
            guard isReadyToPersist else { return }
            Task { await updateReminderSchedule() }
        }
    }
    var reminderTime: Date {
        didSet {
            persistIfReady()
            guard isReadyToPersist, reminderEnabled else { return }
            Task { await updateReminderSchedule() }
        }
    }
    var notificationAccessDenied = false

    private let calendar = Calendar.autoupdatingCurrent
    private let storage = UserDefaults.standard
    private let notificationCenter = UNUserNotificationCenter.current()
    private var isReadyToPersist = false

    init() {
        if let snapshot = Self.loadSnapshot() {
            userName = snapshot.userName
            profileSymbol = snapshot.profileSymbol
            profileImageData = snapshot.profileImageData
            goalTitle = snapshot.goalTitle
            goalDate = snapshot.goalDate
            selectedThemeID = snapshot.selectedThemeID
            skills = snapshot.skills
            sessions = snapshot.sessions
            friends = snapshot.friends
            reminderEnabled = snapshot.reminderEnabled
            reminderTime = snapshot.reminderTime
        } else {
            userName = ""
            profileSymbol = "figure.run"
            profileImageData = nil
            goalTitle = ""
            goalDate = Calendar.autoupdatingCurrent.date(byAdding: .day, value: 24, to: Date()) ?? Date()
            selectedThemeID = "orange"
            skills = Self.defaultSkills
            sessions = []
            friends = []
            reminderEnabled = false
            reminderTime = defaultReminderTime()
        }

        isReadyToPersist = true
        Task {
            await refreshNotificationPermissionState()
            await updateReminderSchedule()
        }
    }

    var theme: AppTheme {
        AppTheme.theme(for: selectedThemeID)
    }

    var reminderTimeText: String {
        reminderTime.formatted(date: .omitted, time: .shortened)
    }

    var reminderStatusText: String {
        if reminderEnabled {
            return "Daily reminder at \(reminderTimeText)."
        }
        if notificationAccessDenied {
            return "Notifications are currently off. You can enable them in Settings."
        }
        return "Set a time and get nudged to do your 15 minutes."
    }

    var todaysSession: PracticeSession? {
        sessions.first { calendar.isDateInToday($0.date) }
    }

    var completedToday: Bool {
        todaysSession?.completed == true
    }

    var currentStreak: Int {
        streakLength(in: uniqueCompletedDays, from: Date())
    }

    var longestStreak: Int {
        let days = uniqueCompletedDays.sorted()
        guard !days.isEmpty else { return 0 }

        var longest = 1
        var running = 1

        for index in 1..<days.count {
            let previous = days[index - 1]
            let current = days[index]
            let difference = calendar.dateComponents([.day], from: previous, to: current).day ?? 0

            if difference == 1 {
                running += 1
                longest = max(longest, running)
            } else {
                running = 1
            }
        }

        return longest
    }

    var completedThisWeek: Int {
        weekSessions.filter(\.completed).count
    }

    var weeklyGoalProgress: Double {
        Double(completedThisWeek) / 7.0
    }

    var weeklyStatusText: String {
        switch completedThisWeek {
        case 7:
            "Perfect week. Keep that energy."
        case 5...6:
            "Strong week. One more push."
        case 3...4:
            "You are building momentum."
        default:
            "Start with today. Fifteen minutes counts."
        }
    }

    var totalSessions: Int {
        sessions.filter(\.completed).count
    }

    var daysUntilGoal: Int {
        max(calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: goalDate)).day ?? 0, 0)
    }

    var goalCountdownText: String {
        guard !goalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "No target set yet."
        }
        if daysUntilGoal == 0 {
            return "Goal day is here."
        }
        if daysUntilGoal == 1 {
            return "1 day to go."
        }
        return "\(daysUntilGoal) days to go."
    }

    var weekSessions: [PracticeSession] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return [] }
        return sessions
            .filter { interval.contains($0.date) }
            .sorted { $0.date > $1.date }
    }

    var recentSessions: [PracticeSession] {
        sessions
            .filter(\.completed)
            .sorted { $0.date > $1.date }
    }

    var skillCounts: [(skill: PracticeSkill, count: Int)] {
        let counts = sessions
            .filter(\.completed)
            .reduce(into: [String: Int]()) { result, session in
                session.skillIDs.forEach { result[$0, default: 0] += 1 }
            }

        return skills
            .map { ($0, counts[$0.id, default: 0]) }
            .sorted { lhs, rhs in
                if lhs.count == rhs.count {
                    return lhs.skill.sortOrder < rhs.skill.sortOrder
                }
                return lhs.count > rhs.count
            }
    }

    var leaderboard: [Friend] {
        let yourName = userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "You" : userName
        let you = Friend(
            name: yourName,
            currentStreak: currentStreak,
            completedToday: completedToday,
            completedThisWeek: completedThisWeek
        )

        return ([you] + friends).sorted { lhs, rhs in
            if lhs.completedThisWeek == rhs.completedThisWeek {
                return lhs.currentStreak > rhs.currentStreak
            }
            return lhs.completedThisWeek > rhs.completedThisWeek
        }
    }

    var weekDays: [Date] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return [] }

        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: interval.start)
        }
    }

    func isCompleted(on date: Date) -> Bool {
        sessions.contains { session in
            session.completed && calendar.isDate(session.date, inSameDayAs: date)
        }
    }

    func skills(for date: Date) -> [PracticeSkill] {
        let session = sessions.first { calendar.isDate($0.date, inSameDayAs: date) }
        return session.map(skillModels(for:)) ?? []
    }

    func skillModels(for session: PracticeSession) -> [PracticeSkill] {
        session.skillIDs
            .compactMap(skill(for:))
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    func skill(for id: String) -> PracticeSkill? {
        skills.first { $0.id == id }
    }

    func addSkill(title: String, symbol: String = "scope") {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let alreadyExists = skills.contains { $0.title.localizedCaseInsensitiveCompare(trimmedTitle) == .orderedSame }
        guard !alreadyExists else { return }

        skills.append(
            PracticeSkill(
                title: trimmedTitle,
                symbol: symbol,
                sortOrder: (skills.map(\.sortOrder).max() ?? -1) + 1
            )
        )
    }

    func updateProfileImage(data: Data?) {
        profileImageData = data
    }

    func resetAllData() {
        userName = ""
        profileSymbol = "figure.run"
        profileImageData = nil
        goalTitle = ""
        goalDate = calendar.date(byAdding: .day, value: 24, to: Date()) ?? Date()
        selectedThemeID = "orange"
        skills = Self.defaultSkills
        sessions = []
        friends = []
        reminderEnabled = false
        reminderTime = defaultReminderTime()
    }

    func updateReminderEnabled(_ enabled: Bool) async {
        if enabled {
            let granted = await requestNotificationPermissionIfNeeded()
            await MainActor.run {
                reminderEnabled = granted
            }
        } else {
            await MainActor.run {
                reminderEnabled = false
            }
        }

        await refreshNotificationPermissionState()
        await updateReminderSchedule()
    }

    func saveTodaySession(skillIDs: Set<String>, note: String) {
        if let index = sessions.firstIndex(where: { calendar.isDateInToday($0.date) }) {
            sessions[index].skillIDs = skillIDs
            sessions[index].note = note
            sessions[index].durationMinutes = 15
            sessions[index].completed = true
            sessions[index].date = Date()
        } else {
            sessions.append(
                PracticeSession(
                    date: Date(),
                    skillIDs: skillIDs,
                    note: note,
                    completed: true
                )
            )
        }
    }

    private var uniqueCompletedDays: [Date] {
        let normalizedDays = sessions
            .filter(\.completed)
            .map { calendar.startOfDay(for: $0.date) }

        return Array(Set(normalizedDays))
    }

    private func streakLength(in completedDays: [Date], from anchorDate: Date) -> Int {
        let completed = Set(completedDays.map { calendar.startOfDay(for: $0) })
        var streak = 0
        var pointer = calendar.startOfDay(for: anchorDate)

        if !completed.contains(pointer) {
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: pointer),
                  completed.contains(previousDay) else {
                return 0
            }
            pointer = previousDay
        }

        while completed.contains(pointer) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: pointer) else {
                break
            }
            pointer = previousDay
        }

        return streak
    }

    private func persistIfReady() {
        guard isReadyToPersist else { return }
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        storage.set(data, forKey: Self.snapshotKey)
    }

    private var snapshot: Snapshot {
        Snapshot(
            userName: userName,
            profileSymbol: profileSymbol,
            profileImageData: profileImageData,
            goalTitle: goalTitle,
            goalDate: goalDate,
            selectedThemeID: selectedThemeID,
            skills: skills,
            sessions: sessions,
            friends: friends,
            reminderEnabled: reminderEnabled,
            reminderTime: reminderTime
        )
    }

    private func refreshNotificationPermissionState() async {
        let settings = await notificationCenter.notificationSettings()
        await MainActor.run {
            notificationAccessDenied = settings.authorizationStatus == .denied
        }
    }

    private func requestNotificationPermissionIfNeeded() async -> Bool {
        let settings = await notificationCenter.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .denied:
            await MainActor.run {
                notificationAccessDenied = true
            }
            return false
        case .notDetermined:
            let granted = (try? await notificationCenter.requestAuthorization(options: [.alert, .sound])) ?? false
            await MainActor.run {
                notificationAccessDenied = !granted
            }
            return granted
        @unknown default:
            return false
        }
    }

    private func updateReminderSchedule() async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [Self.reminderIdentifier])
        guard reminderEnabled else { return }

        let settings = await notificationCenter.notificationSettings()
        guard [.authorized, .provisional, .ephemeral].contains(settings.authorizationStatus) else { return }

        var components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        components.calendar = calendar

        let content = UNMutableNotificationContent()
        content.title = "Time for your 15 minutes"
        content.body = "A short field hockey session today keeps the streak moving."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: Self.reminderIdentifier, content: content, trigger: trigger)

        try? await notificationCenter.add(request)
    }
}

private extension AppStore {
    static let snapshotKey = "app_store_snapshot_v1"
    static let reminderIdentifier = "daily-practice-reminder"

    static let defaultSkills: [PracticeSkill] = [
        PracticeSkill(id: "goal-shooting", title: "Goal shooting", symbol: "scope", sortOrder: 0),
        PracticeSkill(id: "dribbling", title: "Dribbling", symbol: "figure.run", sortOrder: 1),
        PracticeSkill(id: "passing", title: "Passing", symbol: "arrow.left.arrow.right", sortOrder: 2),
        PracticeSkill(id: "defending", title: "Defending", symbol: "shield", sortOrder: 3),
        PracticeSkill(id: "stick-skills", title: "Stick skills", symbol: "sparkles", sortOrder: 4),
        PracticeSkill(id: "overheads", title: "Overheads", symbol: "arrow.up.circle", sortOrder: 5),
        PracticeSkill(id: "trapping", title: "Trapping", symbol: "hand.raised", sortOrder: 6),
        PracticeSkill(id: "footwork", title: "Footwork", symbol: "shoeprints.fill", sortOrder: 7)
    ]

    static func loadSnapshot() -> Snapshot? {
        guard let data = UserDefaults.standard.data(forKey: snapshotKey) else { return nil }
        return try? JSONDecoder().decode(Snapshot.self, from: data)
    }

    struct Snapshot: Codable {
        var userName: String
        var profileSymbol: String
        var profileImageData: Data?
        var goalTitle: String
        var goalDate: Date
        var selectedThemeID: String
        var skills: [PracticeSkill]
        var sessions: [PracticeSession]
        var friends: [Friend]
        var reminderEnabled: Bool = false
        var reminderTime: Date = defaultReminderTime()
    }
}

private func defaultReminderTime() -> Date {
    Calendar.autoupdatingCurrent.date(
        bySettingHour: 19,
        minute: 0,
        second: 0,
        of: Date()
    ) ?? Date()
}
