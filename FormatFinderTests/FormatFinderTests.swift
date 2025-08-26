import XCTest
@testable import FormatFinder

final class FormatFinderTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Model Tests
    
    func testGolfFormatModelInitialization() throws {
        let format = GolfFormat(
            id: "scramble",
            name: "Scramble",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "All players hit from the best shot",
            howToPlay: ["Everyone tees off", "Choose the best drive"],
            scoringExample: "Team score: 4",
            diagram: "scramble_diagram"
        )
        
        XCTAssertEqual(format.id, "scramble")
        XCTAssertEqual(format.name, "Scramble")
        XCTAssertEqual(format.category, "tournament")
        XCTAssertEqual(format.playerCount, "2-4 players")
        XCTAssertEqual(format.difficulty, "easy")
        XCTAssertEqual(format.shortDescription, "All players hit from the best shot")
        XCTAssertEqual(format.howToPlay.count, 2)
        XCTAssertEqual(format.scoringExample, "Team score: 4")
        XCTAssertEqual(format.diagram, "scramble_diagram")
    }
    
    func testGolfFormatDecodingFromJSON() throws {
        let jsonData = """
        {
            "id": "best-ball",
            "name": "Best Ball",
            "category": "tournament",
            "playerCount": "2-4 players",
            "difficulty": "easy",
            "shortDescription": "Count best score per hole",
            "howToPlay": ["Everyone plays their own ball", "Record best score"],
            "scoringExample": "Best score: 3",
            "diagram": "best_ball_diagram"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let format = try decoder.decode(GolfFormat.self, from: jsonData)
        
        XCTAssertEqual(format.id, "best-ball")
        XCTAssertEqual(format.name, "Best Ball")
        XCTAssertEqual(format.category, "tournament")
        XCTAssertEqual(format.howToPlay.count, 2)
    }
    
    func testFormatsDataLoadingFromBundle() throws {
        let dataLoader = FormatsDataLoader()
        let formats = try dataLoader.loadFormats()
        
        XCTAssertEqual(formats.count, 10)
        XCTAssertTrue(formats.contains(where: { $0.id == "scramble" }))
        XCTAssertTrue(formats.contains(where: { $0.id == "best-ball" }))
        XCTAssertTrue(formats.contains(where: { $0.id == "alternate-shot" }))
    }
    
    // MARK: - ViewModel Tests
    
    func testFormatsViewModelInitialization() throws {
        let viewModel = FormatsViewModel()
        
        XCTAssertFalse(viewModel.formats.isEmpty)
        XCTAssertEqual(viewModel.formats.count, 10)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertEqual(viewModel.selectedFilter, .all)
    }
    
    func testFormatsViewModelFiltering() throws {
        let viewModel = FormatsViewModel()
        
        // Test tournament filter
        viewModel.selectedFilter = .tournament
        let tournamentFormats = viewModel.filteredFormats
        XCTAssertTrue(tournamentFormats.allSatisfy { $0.category == "tournament" })
        
        // Test betting filter
        viewModel.selectedFilter = .betting
        let bettingFormats = viewModel.filteredFormats
        XCTAssertTrue(bettingFormats.allSatisfy { $0.category == "betting" })
        
        // Test all filter
        viewModel.selectedFilter = .all
        XCTAssertEqual(viewModel.filteredFormats.count, 10)
    }
    
    func testFormatsViewModelSearching() throws {
        let viewModel = FormatsViewModel()
        
        // Test search by name
        viewModel.searchText = "Scramble"
        XCTAssertTrue(viewModel.filteredFormats.contains(where: { $0.name == "Scramble" }))
        XCTAssertEqual(viewModel.filteredFormats.count, 1)
        
        // Test case-insensitive search
        viewModel.searchText = "best"
        XCTAssertTrue(viewModel.filteredFormats.contains(where: { $0.name.contains("Best") }))
        
        // Test empty search
        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filteredFormats.count, 10)
    }
    
    func testFormatsViewModelCombinedFilterAndSearch() throws {
        let viewModel = FormatsViewModel()
        
        viewModel.selectedFilter = .tournament
        viewModel.searchText = "Scramble"
        
        let results = viewModel.filteredFormats
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Scramble")
        XCTAssertEqual(results.first?.category, "tournament")
    }
    
    // MARK: - Bookmarks Tests
    
    func testBookmarksManagerAddBookmark() throws {
        let manager = BookmarksManager()
        let formatId = "scramble"
        
        manager.addBookmark(formatId: formatId)
        XCTAssertTrue(manager.isBookmarked(formatId: formatId))
        XCTAssertTrue(manager.bookmarkedIds.contains(formatId))
    }
    
    func testBookmarksManagerRemoveBookmark() throws {
        let manager = BookmarksManager()
        let formatId = "scramble"
        
        manager.addBookmark(formatId: formatId)
        XCTAssertTrue(manager.isBookmarked(formatId: formatId))
        
        manager.removeBookmark(formatId: formatId)
        XCTAssertFalse(manager.isBookmarked(formatId: formatId))
        XCTAssertFalse(manager.bookmarkedIds.contains(formatId))
    }
    
    func testBookmarksManagerToggleBookmark() throws {
        let manager = BookmarksManager()
        let formatId = "scramble"
        
        // Initially not bookmarked
        XCTAssertFalse(manager.isBookmarked(formatId: formatId))
        
        // Toggle to bookmark
        manager.toggleBookmark(formatId: formatId)
        XCTAssertTrue(manager.isBookmarked(formatId: formatId))
        
        // Toggle to remove bookmark
        manager.toggleBookmark(formatId: formatId)
        XCTAssertFalse(manager.isBookmarked(formatId: formatId))
    }
    
    func testBookmarksManagerPersistence() throws {
        let manager1 = BookmarksManager()
        let formatId = "scramble"
        
        manager1.addBookmark(formatId: formatId)
        
        // Create new instance to test persistence
        let manager2 = BookmarksManager()
        XCTAssertTrue(manager2.isBookmarked(formatId: formatId))
    }
    
    func testBookmarksManagerGetBookmarkedFormats() throws {
        let manager = BookmarksManager()
        let viewModel = FormatsViewModel()
        
        manager.addBookmark(formatId: "scramble")
        manager.addBookmark(formatId: "best-ball")
        
        let bookmarkedFormats = manager.getBookmarkedFormats(from: viewModel.formats)
        XCTAssertEqual(bookmarkedFormats.count, 2)
        XCTAssertTrue(bookmarkedFormats.contains(where: { $0.id == "scramble" }))
        XCTAssertTrue(bookmarkedFormats.contains(where: { $0.id == "best-ball" }))
    }
    
    // MARK: - UI Component Tests
    
    func testFormatCardViewInitialization() throws {
        let format = GolfFormat(
            id: "scramble",
            name: "Scramble",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "All players hit from the best shot",
            howToPlay: ["Everyone tees off"],
            scoringExample: "Team score: 4",
            diagram: "scramble_diagram"
        )
        
        let card = FormatCardView(format: format)
        XCTAssertNotNil(card)
    }
    
    func testDifficultyBadgeColors() throws {
        let easyBadge = DifficultyBadge(difficulty: "easy")
        let mediumBadge = DifficultyBadge(difficulty: "medium")
        let complexBadge = DifficultyBadge(difficulty: "complex")
        
        XCTAssertNotNil(easyBadge)
        XCTAssertNotNil(mediumBadge)
        XCTAssertNotNil(complexBadge)
    }
    
    func testCategoryFilterChipSelection() throws {
        var selectedFilter = CategoryFilter.all
        
        let allChip = CategoryFilterChip(
            title: "All",
            isSelected: selectedFilter == .all,
            action: { selectedFilter = .all }
        )
        
        XCTAssertNotNil(allChip)
        XCTAssertEqual(selectedFilter, .all)
    }
    
    // MARK: - Navigation Tests
    
    func testNavigationFromHomeToDetail() throws {
        let coordinator = NavigationCoordinator()
        let format = GolfFormat(
            id: "scramble",
            name: "Scramble",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "All players hit from the best shot",
            howToPlay: ["Everyone tees off"],
            scoringExample: "Team score: 4",
            diagram: "scramble_diagram"
        )
        
        coordinator.navigateToDetail(format: format)
        XCTAssertEqual(coordinator.currentView, .detail(format))
    }
    
    func testTabBarSelection() throws {
        let tabManager = TabBarManager()
        
        XCTAssertEqual(tabManager.selectedTab, .browse)
        
        tabManager.selectedTab = .saved
        XCTAssertEqual(tabManager.selectedTab, .saved)
        
        tabManager.selectedTab = .browse
        XCTAssertEqual(tabManager.selectedTab, .browse)
    }
    
    // MARK: - Dark Mode Tests
    
    func testColorSchemeAdaptation() throws {
        let lightColors = ColorTheme(colorScheme: .light)
        let darkColors = ColorTheme(colorScheme: .dark)
        
        XCTAssertNotEqual(lightColors.background, darkColors.background)
        XCTAssertNotEqual(lightColors.foreground, darkColors.foreground)
        XCTAssertEqual(lightColors.accent, darkColors.accent) // Accent should remain consistent
    }
    
    // MARK: - Performance Tests
    
    func testFormatsLoadingPerformance() throws {
        measure {
            let dataLoader = FormatsDataLoader()
            _ = try? dataLoader.loadFormats()
        }
    }
    
    func testSearchPerformance() throws {
        let viewModel = FormatsViewModel()
        
        measure {
            viewModel.searchText = "S"
            _ = viewModel.filteredFormats
            viewModel.searchText = "Sc"
            _ = viewModel.filteredFormats
            viewModel.searchText = "Scramble"
            _ = viewModel.filteredFormats
        }
    }
    
    // MARK: - Edge Cases
    
    func testEmptySearchResults() throws {
        let viewModel = FormatsViewModel()
        
        viewModel.searchText = "NonexistentFormat"
        XCTAssertTrue(viewModel.filteredFormats.isEmpty)
    }
    
    func testSpecialCharactersInSearch() throws {
        let viewModel = FormatsViewModel()
        
        viewModel.searchText = "!@#$%"
        XCTAssertTrue(viewModel.filteredFormats.isEmpty)
    }
    
    func testMaxBookmarksLimit() throws {
        let manager = BookmarksManager()
        
        // Add all formats as bookmarks
        for i in 0..<10 {
            manager.addBookmark(formatId: "format\(i)")
        }
        
        XCTAssertEqual(manager.bookmarkedIds.count, 10)
    }
}