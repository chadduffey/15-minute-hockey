import SwiftUI
import UIKit

struct TopBannerView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        Group {
            if let uiImage = UIImage(named: "TopBannerLogo") {
                bannerImage(uiImage)
            } else {
                fallbackBanner
            }
        }
    }

    private func bannerImage(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.top, 4)
            .padding(.bottom, 8)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.white.opacity(0.12))
            )
    }

    private var fallbackBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.white.opacity(0.10))

            VStack(spacing: 12) {
                ZStack {
                    Capsule()
                        .fill(.white.opacity(0.22))
                        .frame(width: 118, height: 14)
                        .rotationEffect(.degrees(-34))
                        .offset(x: -74, y: 4)

                    Capsule()
                        .fill(.white.opacity(0.22))
                        .frame(width: 118, height: 14)
                        .rotationEffect(.degrees(34))
                        .offset(x: 74, y: 4)

                    Circle()
                        .fill(.white.opacity(0.9))
                        .frame(width: 22, height: 22)
                        .overlay(Circle().stroke(store.theme.primaryDark.opacity(0.15), lineWidth: 2))
                        .offset(y: 66)

                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 112, height: 112)
                        Circle()
                            .stroke(.white.opacity(0.92), lineWidth: 10)
                            .frame(width: 128, height: 128)
                        Circle()
                            .stroke(store.theme.primaryDark.opacity(0.16), lineWidth: 3)
                            .frame(width: 104, height: 104)

                        VStack(spacing: 2) {
                            Text("15")
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundStyle(store.theme.primaryDark)
                            Text("MIN")
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                                .foregroundStyle(store.theme.primaryDark.opacity(0.82))
                        }

                        Circle()
                            .fill(store.theme.primaryDark)
                            .frame(width: 16, height: 16)
                            .offset(x: -8, y: 3)

                        Capsule()
                            .fill(store.theme.primaryDark)
                            .frame(width: 54, height: 10)
                            .offset(x: 16, y: 3)

                        Capsule()
                            .fill(store.theme.primaryDark.opacity(0.75))
                            .frame(width: 34, height: 8)
                            .rotationEffect(.degrees(-55))
                            .offset(x: 7, y: -22)
                    }
                    .shadow(color: .black.opacity(0.14), radius: 12, y: 4)
                }
                .padding(.top, 10)

                VStack(spacing: 2) {
                    Text("15 MINUTE")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text("HOCKEY")
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundStyle(store.theme.primarySoft)
                }

                Text("Add your provided logo as an asset named TopBannerLogo to replace this banner.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.82))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 4)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 14)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
    }
}
