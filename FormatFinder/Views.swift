import SwiftUI

// MARK: - Components

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search formats...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
                .submitLabel(.search)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

struct CategoryFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "2E7D32") : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct FilterChipsView: View {
    @Binding var selectedFilter: CategoryFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(CategoryFilter.allCases, id: \.self) { filter in
                    CategoryFilterChip(
                        title: filter.displayName,
                        isSelected: selectedFilter == filter,
                        action: { selectedFilter = filter }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

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
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(white: 0.07) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
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

// MARK: - Screens

struct HomeView: View {
    @StateObject private var viewModel = FormatsViewModel()
    @StateObject private var bookmarksViewModel = BookmarksViewModel()
    @State private var selectedFormat: GolfFormat?
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                
                FilterChipsView(selectedFilter: $viewModel.selectedFilter)
                    .padding(.bottom, 12)
                
                if viewModel.filteredFormats.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.filteredFormats) { format in
                                FormatCardView(format: format)
                                    .onTapGesture {
                                        selectedFormat = format
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Golf Formats")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(UIColor.systemBackground))
            .sheet(item: $selectedFormat) { format in
                FormatDetailView(
                    format: format,
                    bookmarksViewModel: bookmarksViewModel
                )
            }
        }
    }
}

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
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Label(format.playerCount, systemImage: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                DifficultyBadge(difficulty: format.difficulty)
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
            
            ForEach(Array(format.howToPlay.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1).")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "2E7D32"))
                        .frame(width: 24, alignment: .trailing)
                    
                    Text(step)
                        .font(.system(size: 16))
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
            
            Text(format.scoringExample)
                .font(.system(size: 16))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "2E7D32").opacity(0.05))
                )
        }
    }
}

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
                    EmptyBookmarksView()
                } else {
                    List {
                        ForEach(bookmarkedFormats) { format in
                            BookmarkRowView(format: format)
                                .onTapGesture {
                                    selectedFormat = format
                                }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Saved Formats")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedFormat) { format in
                FormatDetailView(
                    format: format,
                    bookmarksViewModel: bookmarksViewModel
                )
            }
        }
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
                
                Text(format.shortDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
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

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No formats found")
                .font(.system(size: 20, weight: .semibold))
            
            Text("Try adjusting your search or filters")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct EmptyBookmarksView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bookmark")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No saved formats yet")
                .font(.system(size: 22, weight: .semibold))
            
            Text("Tap the bookmark icon on any format to save it here")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}