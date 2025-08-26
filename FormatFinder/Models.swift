import Foundation
import SwiftUI

// MARK: - Models

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

enum AppTab {
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

// MARK: - Services

class FormatsDataLoader {
    enum LoaderError: Error {
        case fileNotFound
        case decodingError
    }
    
    func loadFormats() throws -> [GolfFormat] {
        guard let url = Bundle.main.url(forResource: "formats", withExtension: "json") else {
            // Return hardcoded data if file not found
            return Self.defaultFormats
        }
        
        do {
            let data = try Data(contentsOf: url)
            let formatsData = try JSONDecoder().decode(FormatsData.self, from: data)
            return formatsData.formats
        } catch {
            return Self.defaultFormats
        }
    }
    
    static let defaultFormats = [
        GolfFormat(
            id: "scramble",
            name: "Scramble",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "All players hit from the best shot location",
            howToPlay: [
                "Everyone tees off on each hole",
                "The team selects the best drive",
                "All players hit their next shot from that spot",
                "Continue selecting the best shot until the ball is holed",
                "Record one team score for each hole"
            ],
            scoringExample: "Hole 1 (Par 4): Team uses Sarah's drive from the fairway, then Mike's approach to the green, then Sarah's chip close to the pin, and Alex makes the putt. Team score: 4",
            diagram: "scramble_diagram"
        ),
        GolfFormat(
            id: "best-ball",
            name: "Best Ball",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "Each player plays their own ball, count the best score",
            howToPlay: [
                "Everyone plays their own ball throughout the hole",
                "Each player records their individual score",
                "The lowest score among team members becomes the team score",
                "If multiple players tie for best, use that score",
                "Continue for all 18 holes"
            ],
            scoringExample: "Hole 1 (Par 4): Player A scores 5, Player B scores 4, Player C scores 6, Player D scores 4. Team score: 4 (best ball)",
            diagram: "best_ball_diagram"
        ),
        GolfFormat(
            id: "skins",
            name: "Skins",
            category: "betting",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "Win a hole outright to claim the skin, ties carry over",
            howToPlay: [
                "Each hole is worth a 'skin' (predetermined value)",
                "Lowest score on a hole wins the skin",
                "If players tie, the skin carries to the next hole",
                "Carried skins accumulate until someone wins a hole outright",
                "Player with most skins/money at the end wins"
            ],
            scoringExample: "Hole 1: Tie (skin carries). Hole 2: Tie (2 skins carry). Hole 3: Player A wins with birdie, claims 3 skins",
            diagram: "skins_diagram"
        )
    ]
}

class BookmarksManager {
    private let bookmarksKey = "FormatFinder.Bookmarks"
    private let userDefaults = UserDefaults.standard
    
    var bookmarkedIds: Set<String> {
        get {
            let array = userDefaults.array(forKey: bookmarksKey) as? [String] ?? []
            return Set(array)
        }
        set {
            userDefaults.set(Array(newValue), forKey: bookmarksKey)
        }
    }
    
    func toggleBookmark(formatId: String) {
        if bookmarkedIds.contains(formatId) {
            var ids = bookmarkedIds
            ids.remove(formatId)
            bookmarkedIds = ids
        } else {
            var ids = bookmarkedIds
            ids.insert(formatId)
            bookmarkedIds = ids
        }
    }
    
    func isBookmarked(formatId: String) -> Bool {
        bookmarkedIds.contains(formatId)
    }
}

// MARK: - ViewModels

class FormatsViewModel: ObservableObject {
    @Published var formats: [GolfFormat] = []
    @Published var searchText = ""
    @Published var selectedFilter: CategoryFilter = .all
    
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
        do {
            formats = try dataLoader.loadFormats()
        } catch {
            formats = FormatsDataLoader.defaultFormats
        }
    }
}

class BookmarksViewModel: ObservableObject {
    @Published var bookmarkedIds: Set<String> = []
    private let manager = BookmarksManager()
    
    init() {
        bookmarkedIds = manager.bookmarkedIds
    }
    
    func toggleBookmark(formatId: String) {
        manager.toggleBookmark(formatId: formatId)
        bookmarkedIds = manager.bookmarkedIds
    }
    
    func isBookmarked(formatId: String) -> Bool {
        bookmarkedIds.contains(formatId)
    }
    
    func getBookmarkedFormats(from formats: [GolfFormat]) -> [GolfFormat] {
        formats.filter { bookmarkedIds.contains($0.id) }
    }
}

// MARK: - Color Extension

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