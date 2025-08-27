import SwiftUI

// MARK: - Data Compatibility Layer
// This file bridges the gap between DataStore and DataManager

typealias DataManager = DataStore

extension DataStore {
    // Add DataManager compatibility methods
    var formats: [GolfFormat] {
        get { Self.defaultFormats }
        set { /* Not used in current implementation */ }
    }
    
    func toggleBookmark(for format: GolfFormat) {
        toggleBookmark(format.id)
    }
    
    func isBookmarked(_ format: GolfFormat) -> Bool {
        isBookmarked(format.id)
    }
    
    var bookmarkedFormats: [GolfFormat] {
        formats.filter { isBookmarked($0.id) }
    }
    
    var filteredFormats: [GolfFormat] {
        formats.filter { format in
            let matchesSearch = searchText.isEmpty ||
                format.name.localizedCaseInsensitiveContains(searchText) ||
                format.shortDescription.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = selectedCategory == "All" || 
                format.category.lowercased() == selectedCategory.lowercased()
            
            return matchesSearch && matchesCategory
        }
    }
}

// MARK: - Enhanced GolfFormat Extensions
extension GolfFormat {
    var icon: String {
        switch category.lowercased() {
        case "tournament": return "trophy"
        case "betting": return "flag"
        case "team": return "team"
        case "strategy": return "chart"
        default: return "golfball"
        }
    }
    
    var color: Color {
        switch category.lowercased() {
        case "tournament": return HeadspaceColors.sky
        case "betting": return HeadspaceColors.coral
        case "team": return HeadspaceColors.mint
        case "strategy": return HeadspaceColors.lavender
        default: return HeadspaceColors.purple
        }
    }
    
    var players: String {
        return playerCount
    }
    
    var description: String {
        return shortDescription
    }
    
    var example: String {
        return scoringExample
    }
}