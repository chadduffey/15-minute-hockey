import SwiftUI

struct CategoryChip: View {
    @Environment(AppStore.self) private var store

    let skill: PracticeSkill
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: skill.symbol)
                .font(.subheadline.weight(.bold))
            Text(skill.title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(isSelected ? store.theme.primary : Color.black.opacity(0.05))
        .foregroundStyle(isSelected ? .white : .primary)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
