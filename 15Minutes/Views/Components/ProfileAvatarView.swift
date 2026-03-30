import SwiftUI
import UIKit

struct ProfileAvatarView: View {
    let imageData: Data?
    let systemName: String
    let theme: AppTheme
    var size: CGFloat = 72

    var body: some View {
        Group {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Circle()
                        .fill(theme.primary)
                    Image(systemName: systemName)
                        .font(.system(size: size * 0.38, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(.white.opacity(0.8), lineWidth: 2))
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }
}
