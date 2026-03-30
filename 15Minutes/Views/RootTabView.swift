import SwiftUI

struct RootTabView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack {
                    HomeView()
                }
            }

            Tab("Log", systemImage: "plus.circle.fill") {
                NavigationStack {
                    LogSessionView()
                }
            }

            Tab("Progress", systemImage: "chart.line.uptrend.xyaxis") {
                NavigationStack {
                    ProgressView()
                }
            }

            Tab("Profile", systemImage: "person.crop.circle.fill") {
                NavigationStack {
                    ProfileView()
                }
            }
        }
        .tint(store.theme.primary)
    }
}
