import SwiftUI

struct ColorTheme {
    let colorScheme: ColorScheme
    
    var background: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    var foreground: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var card: Color {
        colorScheme == .dark ? Color(white: 0.07) : Color.white
    }
    
    var accent: Color {
        Color(red: 46/255, green: 125/255, blue: 50/255)
    }
    
    var muted: Color {
        colorScheme == .dark ? Color(white: 0.15) : Color(white: 0.96)
    }
    
    var border: Color {
        colorScheme == .dark ? Color(white: 0.15) : Color(white: 0.92)
    }
    
    static let gradientBlue = LinearGradient(
        colors: [Color(hex: "3b82f6"), Color(hex: "06b6d4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGreen = LinearGradient(
        colors: [Color(hex: "10b981"), Color(hex: "34d399")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientPurple = LinearGradient(
        colors: [Color(hex: "8b5cf6"), Color(hex: "ec4899")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientOrange = LinearGradient(
        colors: [Color(hex: "f97316"), Color(hex: "ef4444")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}