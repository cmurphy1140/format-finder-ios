import SwiftUI

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
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredFormats.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.filteredFormats) { format in
                                FormatCardView(format: format)
                                    .onTapGesture {
                                        selectedFormat = format
                                    }
                                    .accessibilityIdentifier("formatCard-\(format.id)")
                            }
                        }
                        .padding()
                    }
                    .accessibilityIdentifier("formatsGrid")
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

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No formats found")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("Try adjusting your search or filters")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}