import SwiftUI

struct WeekProgressView: View {
    @Environment(AppStore.self) private var store

    let days: [Date]
    let isCompleted: (Date) -> Bool

    var body: some View {
        HStack(spacing: 10) {
            ForEach(days, id: \.self) { day in
                VStack(spacing: 8) {
                    Text(day.formatted(.dateTime.weekday(.narrow)))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isCompleted(day) ? store.theme.success : Color.black.opacity(0.06))
                            .frame(height: 54)

                        Image(systemName: isCompleted(day) ? "checkmark" : "minus")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(isCompleted(day) ? .white : .secondary)
                    }

                    Text(day.formatted(.dateTime.day()))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
