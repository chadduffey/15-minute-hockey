import SwiftUI

struct AppTheme: Identifiable, Hashable {
    let id: String
    let name: String
    let primary: Color
    let primaryDark: Color
    let primarySoft: Color
    let backgroundTop: Color
    let backgroundBottom: Color
    let success: Color

    static let presets: [AppTheme] = [
        AppTheme(
            id: "orange",
            name: "Sunburst",
            primary: Color(red: 0.96, green: 0.46, blue: 0.20),
            primaryDark: Color(red: 0.88, green: 0.29, blue: 0.14),
            primarySoft: Color(red: 0.97, green: 0.72, blue: 0.16),
            backgroundTop: Color(red: 0.98, green: 0.95, blue: 0.89),
            backgroundBottom: Color(red: 0.92, green: 0.96, blue: 0.98),
            success: Color(red: 0.15, green: 0.56, blue: 0.43)
        ),
        AppTheme(
            id: "blue",
            name: "Ocean",
            primary: Color(red: 0.18, green: 0.49, blue: 0.89),
            primaryDark: Color(red: 0.10, green: 0.31, blue: 0.65),
            primarySoft: Color(red: 0.34, green: 0.73, blue: 0.95),
            backgroundTop: Color(red: 0.91, green: 0.96, blue: 1.00),
            backgroundBottom: Color(red: 0.94, green: 0.97, blue: 0.93),
            success: Color(red: 0.10, green: 0.55, blue: 0.52)
        ),
        AppTheme(
            id: "green",
            name: "Field",
            primary: Color(red: 0.19, green: 0.58, blue: 0.33),
            primaryDark: Color(red: 0.10, green: 0.39, blue: 0.21),
            primarySoft: Color(red: 0.58, green: 0.79, blue: 0.29),
            backgroundTop: Color(red: 0.93, green: 0.98, blue: 0.92),
            backgroundBottom: Color(red: 0.97, green: 0.95, blue: 0.88),
            success: Color(red: 0.14, green: 0.50, blue: 0.30)
        ),
        AppTheme(
            id: "pink",
            name: "Berry",
            primary: Color(red: 0.86, green: 0.26, blue: 0.47),
            primaryDark: Color(red: 0.61, green: 0.13, blue: 0.32),
            primarySoft: Color(red: 0.96, green: 0.55, blue: 0.65),
            backgroundTop: Color(red: 0.99, green: 0.93, blue: 0.96),
            backgroundBottom: Color(red: 0.95, green: 0.96, blue: 1.00),
            success: Color(red: 0.32, green: 0.55, blue: 0.31)
        ),
        AppTheme(
            id: "slate",
            name: "Slate",
            primary: Color(red: 0.29, green: 0.33, blue: 0.40),
            primaryDark: Color(red: 0.17, green: 0.20, blue: 0.26),
            primarySoft: Color(red: 0.57, green: 0.62, blue: 0.71),
            backgroundTop: Color(red: 0.93, green: 0.94, blue: 0.97),
            backgroundBottom: Color(red: 0.96, green: 0.94, blue: 0.90),
            success: Color(red: 0.21, green: 0.53, blue: 0.52)
        )
    ]

    static func theme(for id: String) -> AppTheme {
        presets.first { $0.id == id } ?? presets[0]
    }
}
