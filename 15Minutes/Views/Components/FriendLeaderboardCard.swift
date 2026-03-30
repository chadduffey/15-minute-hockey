import SwiftUI

struct FriendLeaderboardCard: View {
    @Environment(AppStore.self) private var store

    let friends: [Friend]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(friends.enumerated()), id: \.element.id) { index, friend in
                HStack(spacing: 14) {
                    Text("\(index + 1)")
                        .font(.headline.weight(.bold))
                        .frame(width: 28)

                    Circle()
                        .fill(friend.completedToday ? store.theme.success : Color.black.opacity(0.1))
                        .frame(width: 12, height: 12)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(friend.name)
                            .font(.headline.weight(.bold))
                        Text(friend.completedToday ? "Done today" : "Still to go today")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(friend.completedThisWeek)/7")
                            .font(.headline.weight(.bold))
                        Text("\(friend.currentStreak)-day streak")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(14)
                .background(Color.black.opacity(0.04))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }
}
