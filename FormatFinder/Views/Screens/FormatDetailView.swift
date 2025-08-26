import SwiftUI

struct FormatDetailView: View {
    let format: GolfFormat
    @ObservedObject var bookmarksViewModel: BookmarksViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    diagramSection
                    howToPlaySection
                    scoringExampleSection
                    quickTipSection
                }
                .padding()
            }
            .navigationTitle(format.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        bookmarksViewModel.toggleBookmark(formatId: format.id)
                    }) {
                        Image(systemName: bookmarksViewModel.isBookmarked(formatId: format.id) ? "bookmark.fill" : "bookmark")
                            .foregroundColor(Color(hex: "2E7D32"))
                    }
                    .accessibilityIdentifier("bookmarkButton")
                    .accessibilityLabel(bookmarksViewModel.isBookmarked(formatId: format.id) ? "Remove bookmark" : "Add bookmark")
                }
            }
            .background(Color(UIColor.systemBackground))
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Label(format.playerCount, systemImage: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                DifficultyBadge(difficulty: format.difficulty)
                
                Text(format.category.capitalized)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "2E7D32").opacity(0.1))
                    .foregroundColor(Color(hex: "2E7D32"))
                    .clipShape(Capsule())
            }
            
            Text(format.shortDescription)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
    }
    
    private var diagramSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Visual Guide")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    colors: [Color(hex: "2E7D32").opacity(0.1), Color(hex: "2E7D32").opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "2E7D32").opacity(0.3))
                        Text("Diagram: \(format.diagram)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )
        }
    }
    
    private var howToPlaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to Play:")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            ForEach(Array(format.howToPlay.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1).")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "2E7D32"))
                        .frame(width: 24, alignment: .trailing)
                    
                    Text(step)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(white: 0.07) : Color.gray.opacity(0.05))
        )
    }
    
    private var scoringExampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Scoring Example:")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(format.scoringExample)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "2E7D32").opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "2E7D32").opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private var quickTipSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 20))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Quick Tip")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.orange)
                
                Text(quickTipForFormat())
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.05))
        )
    }
    
    private func quickTipForFormat() -> String {
        switch format.id {
        case "scramble":
            return "Perfect for mixed skill levels - everyone contributes!"
        case "best-ball":
            return "Play your own ball but only count the team's best score."
        case "alternate-shot":
            return "Communication with your partner is key to success."
        case "stableford":
            return "Focus on scoring points, not counting strokes."
        case "match-play":
            return "Each hole is a mini-competition - stay focused!"
        case "skins":
            return "One great hole can win you the entire pot!"
        case "nassau":
            return "Three bets in one - manage your risk wisely."
        case "wolf":
            return "Choose your partners strategically based on their drives."
        case "shamble":
            return "Best of both worlds - team start, individual finish."
        case "chapman":
            return "Strategy matters - choose which ball to play wisely."
        default:
            return "Have fun and enjoy the game!"
        }
    }
}