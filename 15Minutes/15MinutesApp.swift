import SwiftUI

@main
struct FifteenMinutesApp: App {
    @State private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(store)
                .preferredColorScheme(.light)
        }
    }
}
