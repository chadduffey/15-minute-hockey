import SwiftUI

struct LogSessionView: View {
    @Environment(AppStore.self) private var store

    @State private var selectedSkillIDs = Set<String>()
    @State private var note = ""
    @State private var didSave = false
    @FocusState private var noteFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                introCard
                categorySection
                notesSection
                saveButton
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .contentShape(Rectangle())
        .onTapGesture {
            noteFocused = false
        }
        .background(
            LinearGradient(
                colors: [
                    store.theme.backgroundBottom,
                    store.theme.backgroundTop
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Log Today")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadDraft)
        .alert("Session saved", isPresented: $didSave) {
            Button("Nice") { }
        } message: {
            Text("Your 15 minutes has been counted.")
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    noteFocused = false
                }
            }
        }
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("15-minute hockey session", systemImage: "timer")
                .font(.headline.weight(.bold))

            Text("Select what you worked on and add a quick note if you want.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                statPill(title: "Streak", value: "\(store.currentStreak) days")
                statPill(title: "Goal", value: store.goalCountdownText)
            }
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("What did you practice?")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                ForEach(store.skills.sorted { $0.sortOrder < $1.sortOrder }) { skill in
                    Button {
                        toggle(skill)
                    } label: {
                        CategoryChip(skill: skill, isSelected: selectedSkillIDs.contains(skill.id))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick note")
                .font(.title3.weight(.bold))

            TextField("How did it go?", text: $note, axis: .vertical)
                .lineLimit(4, reservesSpace: true)
                .focused($noteFocused)
                .submitLabel(.done)
                .padding(14)
                .background(Color.black.opacity(0.04))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Text("Keep it short. The habit matters more than perfect tracking.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var saveButton: some View {
        Button {
            noteFocused = false
            store.saveTodaySession(skillIDs: selectedSkillIDs, note: note.trimmingCharacters(in: .whitespacesAndNewlines))
            didSave = true
        } label: {
            Text(store.completedToday ? "Update today's 15" : "Complete today's 15")
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [
                            store.theme.primary,
                            store.theme.primaryDark
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func statPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline.weight(.bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.black.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func toggle(_ skill: PracticeSkill) {
        if selectedSkillIDs.contains(skill.id) {
            selectedSkillIDs.remove(skill.id)
        } else {
            selectedSkillIDs.insert(skill.id)
        }
    }

    private func loadDraft() {
        guard selectedSkillIDs.isEmpty && note.isEmpty else { return }
        selectedSkillIDs = store.todaysSession?.skillIDs ?? []
        note = store.todaysSession?.note ?? ""
    }
}
