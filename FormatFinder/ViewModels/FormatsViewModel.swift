import SwiftUI
import Combine

class FormatsViewModel: ObservableObject {
    @Published var formats: [GolfFormat] = []
    @Published var searchText = ""
    @Published var selectedFilter: CategoryFilter = .all
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataLoader = FormatsDataLoader()
    
    init() {
        loadFormats()
    }
    
    var filteredFormats: [GolfFormat] {
        formats.filter { format in
            let matchesSearch = searchText.isEmpty || format.matchesSearchText(searchText)
            let matchesFilter = format.belongsToCategory(selectedFilter)
            return matchesSearch && matchesFilter
        }
    }
    
    func loadFormats() {
        isLoading = true
        errorMessage = nil
        
        do {
            formats = try dataLoader.loadFormats()
        } catch {
            errorMessage = "Failed to load formats"
            formats = []
        }
        
        isLoading = false
    }
    
    func format(by id: String) -> GolfFormat? {
        formats.first { $0.id == id }
    }
    
    func resetFilters() {
        searchText = ""
        selectedFilter = .all
    }
}