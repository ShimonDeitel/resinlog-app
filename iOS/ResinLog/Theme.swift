import SwiftUI

/// Unique palette for Resin Log - Cure Tracker — deep amethyst resin-cast glow with teal cure-light accent.
enum Theme {
    static let background = Color(hex: "#241B2F")
    static let surface = Color(hex: "#241B2F").opacity(0.001) == Color.clear ? Color(hex: "#241B2F") : Color(hex: "#241B2F")
    static let card = Color.white.opacity(0.06)
    static let accent = Color(hex: "#B98CE0")
    static let accentSecondary = Color(hex: "#5FD0C6")
    static let text = Color(hex: "#F3EEFA")
    static let textMuted = Color(hex: "#F3EEFA").opacity(0.6)

    static let titleFont: Font = .system(.title2, design: .rounded).weight(.bold)
    static let headlineFont: Font = .system(.headline, design: .rounded)
    static let bodyFont: Font = .system(.body, design: .rounded)
    static let captionFont: Font = .system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: 1)
    }
}
