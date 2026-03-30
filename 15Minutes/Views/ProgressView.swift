import SwiftUI

struct ProgressView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summaryCard
                categoryCard
                historyCard
            }
            .padding(20)
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
        .navigationTitle("Progress")
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Momentum")
                .font(.title2.weight(.bold))

            HStack(spacing: 12) {
                statCard(value: "\(store.currentStreak)", label: "Current streak")
                statCard(value: "\(store.longestStreak)", label: "Best streak")
                statCard(value: "\(store.totalSessions)", label: "Sessions")
            }
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var categoryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Practice mix")
                .font(.title2.weight(.bold))

            ForEach(store.skillCounts.prefix(5), id: \.skill.id) { entry in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Label(entry.skill.title, systemImage: entry.skill.symbol)
                            .font(.headline)
                        Spacer()
                        Text("\(entry.count)x")
                            .font(.headline.weight(.bold))
                    }

                    GeometryReader { geometry in
                        let width = max(geometry.size.width * CGFloat(entry.count) / CGFloat(max(store.skillCounts.first?.count ?? 1, 1)), 12)
                        RoundedRectangle(cornerRadius: 999, style: .continuous)
                            .fill(store.theme.primary)
                            .frame(width: width, height: 10)
                    }
                    .frame(height: 10)
                }
            }
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var historyCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent sessions")
                .font(.title2.weight(.bold))

            ForEach(store.recentSessions.prefix(6)) { session in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(session.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.headline.weight(.bold))
                        Spacer()
                        Text("\(session.durationMinutes) min")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }

                    let skills = store.skillModels(for: session)

                    if !skills.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(skills) { skill in
                                    CategoryChip(skill: skill, isSelected: true)
                                }
                            }
                        }
                    }

                    if !session.note.isEmpty {
                        Text(session.note)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func statCard(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text(label)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.black.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
