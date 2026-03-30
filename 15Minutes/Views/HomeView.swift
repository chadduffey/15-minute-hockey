import SwiftUI

struct HomeView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                heroCard
                weeklyDashboardCard
                weekCard
                trainingCard
                friendsCard
            }
            .padding(20)
        }
        .background(
            LinearGradient(
                colors: [
                    store.theme.backgroundTop,
                    store.theme.backgroundBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("15 Minute Hockey")
                    .font(.headline.weight(.bold))
            }
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 14) {
                ProfileAvatarView(
                    imageData: store.profileImageData,
                    systemName: store.profileSymbol,
                    theme: store.theme,
                    size: 58
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(store.userName.isEmpty ? "Training dashboard" : "\(store.userName)'s dashboard")
                        .font(.caption.weight(.bold))
                        .textCase(.uppercase)
                        .foregroundStyle(Color.white.opacity(0.70))
                    Text("15 Minute Hockey")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                    Text("Daily field hockey practice")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.white.opacity(0.88))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(store.goalCountdownText)
                        .font(.headline.weight(.bold))
                    Text("to target")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.white.opacity(0.72))
                        .textCase(.uppercase)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(store.goalTitle)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .minimumScaleFactor(0.82)
                    .fixedSize(horizontal: false, vertical: true)

                Text(store.completedToday ? "Session logged. The habit stays alive." : "Put in one sharp 15-minute session today and keep your build-up moving.")
                    .font(.headline)
                    .foregroundStyle(Color.white.opacity(0.90))
            }

            HStack(alignment: .bottom, spacing: 18) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(store.currentStreak)")
                        .font(.system(size: 58, weight: .black, design: .rounded))
                        .contentTransition(.numericText())
                    Text("day streak")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.white.opacity(0.88))
                }

                Rectangle()
                    .fill(Color.white.opacity(0.16))
                    .frame(width: 1, height: 60)

                VStack(alignment: .leading, spacing: 8) {
                    statRow(label: "This week", value: "\(store.completedThisWeek)/7")
                    statRow(label: "Best", value: "\(store.longestStreak) days")
                    statRow(label: "Sessions", value: "\(store.totalSessions)")
                }

                Spacer()
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) {
                    primaryAction
                    statusBadge
                }

                VStack(spacing: 12) {
                    primaryAction
                    statusBadge
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(24)
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        store.theme.primary,
                        store.theme.primaryDark
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(store.theme.primarySoft.opacity(0.28))
                    .frame(width: 220, height: 220)
                    .offset(x: 140, y: -120)

                Circle()
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 170, height: 170)
                    .offset(x: -150, y: 120)
            }
        )
        .foregroundStyle(.white)
        .shadow(color: store.theme.primaryDark.opacity(0.22), radius: 18, y: 10)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var weeklyDashboardCard: some View {
        HStack(spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Build-up")
                    .font(.title2.weight(.black))
                Text("Every session is a vote for being ready on game day.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Label(store.goalTitle, systemImage: "calendar")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(store.theme.primaryDark)
                    .lineLimit(1)
                Text(store.weeklyStatusText)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 14) {
                CompletionRingView(progress: store.weeklyGoalProgress)

                Text(store.goalCountdownText)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(store.theme.success)
                    .textCase(.uppercase)
            }
        }
        .padding(20)
        .background(.white.opacity(0.90))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var weekCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("This week")
                    .font(.title2.weight(.black))
                Spacer()
                Text("\(store.completedThisWeek)/7")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(store.theme.primaryDark)
            }

            WeekProgressView(days: store.weekDays, isCompleted: store.isCompleted(on:))

            if store.completedThisWeek == 7 {
                Text("Perfect week unlocked.")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(store.theme.success)
            } else {
                Text("\(7 - store.completedThisWeek) more day\(store.completedThisWeek == 6 ? "" : "s") to cross off the full week.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var trainingCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Today's focus")
                        .font(.title2.weight(.black))
                    Text(store.completedToday ? "Logged for today" : "Suggested session")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Label("15 min", systemImage: "timer")
                    .font(.subheadline.weight(.bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(store.theme.primary.opacity(0.12))
                    .foregroundStyle(store.theme.primaryDark)
                    .clipShape(Capsule())
            }

            let skills = store.todaysSession.map(store.skillModels(for:)) ?? Array(store.skills.prefix(2))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                ForEach(skills) { skill in
                    CategoryChip(skill: skill, isSelected: true)
                }
            }

            Text(store.todaysSession?.note.isEmpty == false ? store.todaysSession?.note ?? "" : "Pick one or two skills and keep the session simple.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.white.opacity(0.90))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var friendsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Friends")
                    .font(.title2.weight(.black))
                Spacer()
                Text("Leaderboard")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            FriendLeaderboardCard(friends: store.leaderboard)
        }
        .padding(20)
        .background(.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func statRow(label: String, value: String) -> some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.white.opacity(0.72))
                .textCase(.uppercase)
            Text(value)
                .font(.headline.weight(.bold))
        }
    }

    private var primaryAction: some View {
        NavigationLink {
            LogSessionView()
        } label: {
            Text(store.completedToday ? "Update today's session" : "Do your 15 minutes")
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white)
                .foregroundStyle(store.theme.primaryDark)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private var statusBadge: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(store.completedToday ? "Ready for tomorrow" : "Still to complete")
                .font(.caption.weight(.bold))
                .textCase(.uppercase)
                .foregroundStyle(Color.white.opacity(0.72))
            Text(store.completedToday ? "Momentum locked in" : "15 minutes counts")
                .font(.subheadline.weight(.bold))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
