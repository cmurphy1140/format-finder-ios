import SwiftUI

struct FormatCardView: View {
    let format: GolfFormat
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconForCategory(format.category))
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "2E7D32"))
                
                Spacer()
                
                DifficultyBadge(difficulty: format.difficulty)
            }
            
            Text(format.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(format.shortDescription)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(format.playerCount, systemImage: "person.2.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(format.category.capitalized)
                    .font(.system(size: 11, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "2E7D32").opacity(0.1))
                    .foregroundColor(Color(hex: "2E7D32"))
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(format.name), \(format.shortDescription), \(format.playerCount), \(format.difficulty) difficulty")
    }
    
    private var cardBackground: some ShapeStyle {
        if colorScheme == .dark {
            return Color(white: 0.07).opacity(0.95)
        } else {
            return Color.white.opacity(0.95)
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "tournament":
            return "trophy.fill"
        case "betting":
            return "dollarsign.circle.fill"
        default:
            return "flag.fill"
        }
    }
}

struct DifficultyBadge: View {
    let difficulty: String
    
    var body: some View {
        Text(difficulty.capitalized)
            .font(.system(size: 11, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
    
    private var backgroundColor: Color {
        switch difficulty {
        case "easy":
            return .green
        case "medium":
            return .orange
        case "complex":
            return .red
        default:
            return .gray
        }
    }
}