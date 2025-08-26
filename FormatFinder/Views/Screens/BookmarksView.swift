import SwiftUI

struct BookmarksView: View {
    @StateObject private var bookmarksViewModel = BookmarksViewModel()
    @StateObject private var formatsViewModel = FormatsViewModel()
    @State private var selectedFormat: GolfFormat?
    
    var bookmarkedFormats: [GolfFormat] {
        bookmarksViewModel.getBookmarkedFormats(from: formatsViewModel.formats)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if bookmarkedFormats.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(bookmarkedFormats) { format in
                            BookmarkRowView(format: format)
                                .onTapGesture {
                                    selectedFormat = format
                                }
                                .accessibilityIdentifier("saved-\(format.id)")
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let format = bookmarkedFormats[index]
                                bookmarksViewModel.removeBookmark(formatId: format.id)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Saved Formats")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !bookmarkedFormats.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            .sheet(item: $selectedFormat) { format in
                FormatDetailView(
                    format: format,
                    bookmarksViewModel: bookmarksViewModel
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bookmark")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No saved formats yet")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("Tap the bookmark icon on any format to save it here")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

struct BookmarkRowView: View {
    let format: GolfFormat
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconForCategory(format.category))
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "2E7D32"))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(format.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(format.shortDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label(format.playerCount, systemImage: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Text(format.difficulty.capitalized)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(difficultyColor(format.difficulty))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
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
    
    private func difficultyColor(_ difficulty: String) -> Color {
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