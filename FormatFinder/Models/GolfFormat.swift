import Foundation

struct GolfFormat: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let category: String
    let playerCount: String
    let difficulty: String
    let shortDescription: String
    let howToPlay: [String]
    let scoringExample: String
    let diagram: String
    
    var isValid: Bool {
        !id.isEmpty && 
        !name.isEmpty && 
        !shortDescription.isEmpty && 
        !howToPlay.isEmpty && 
        !scoringExample.isEmpty
    }
    
    func belongsToCategory(_ filter: CategoryFilter) -> Bool {
        switch filter {
        case .all:
            return true
        case .tournament:
            return category == "tournament"
        case .betting:
            return category == "betting"
        }
    }
    
    func matchesSearchText(_ searchText: String) -> Bool {
        guard !searchText.isEmpty else { return true }
        
        let lowercasedSearch = searchText.lowercased()
        return name.lowercased().contains(lowercasedSearch) ||
               shortDescription.lowercased().contains(lowercasedSearch)
    }
}

struct FormatsData: Codable {
    let formats: [GolfFormat]
}

enum CategoryFilter: String, CaseIterable {
    case all = "all"
    case tournament = "tournament"
    case betting = "betting"
    
    var displayName: String {
        switch self {
        case .all:
            return "All"
        case .tournament:
            return "Tournament"
        case .betting:
            return "Betting"
        }
    }
}

enum Difficulty: String {
    case easy = "easy"
    case medium = "medium"
    case complex = "complex"
    
    var color: String {
        switch self {
        case .easy:
            return "green"
        case .medium:
            return "orange"
        case .complex:
            return "red"
        }
    }
}

enum Tab {
    case browse
    case saved
    
    var title: String {
        switch self {
        case .browse:
            return "Browse"
        case .saved:
            return "Saved"
        }
    }
    
    var icon: String {
        switch self {
        case .browse:
            return "square.grid.2x2"
        case .saved:
            return "bookmark.fill"
        }
    }
}