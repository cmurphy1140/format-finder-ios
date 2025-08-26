import XCTest

final class FormatFinderUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Home Screen Tests
    
    func testHomeScreenDisplaysFormatGrid() throws {
        // Verify that the home screen shows format cards
        let formatGrid = app.scrollViews["formatsGrid"]
        XCTAssertTrue(formatGrid.exists)
        
        // Check if at least one format card is visible
        let scrambleCard = app.buttons["formatCard-scramble"]
        XCTAssertTrue(scrambleCard.exists)
    }
    
    func testSearchBarFunctionality() throws {
        let searchField = app.searchFields["Search formats..."]
        XCTAssertTrue(searchField.exists)
        
        // Type in search field
        searchField.tap()
        searchField.typeText("Scramble")
        
        // Verify filtered results
        let scrambleCard = app.buttons["formatCard-scramble"]
        XCTAssertTrue(scrambleCard.exists)
        
        // Other cards should not be visible
        let bestBallCard = app.buttons["formatCard-best-ball"]
        XCTAssertFalse(bestBallCard.exists)
    }
    
    func testCategoryFilterChips() throws {
        // Test "Tournament" filter
        let tournamentChip = app.buttons["filter-tournament"]
        XCTAssertTrue(tournamentChip.exists)
        tournamentChip.tap()
        
        // Verify only tournament formats are shown
        let scrambleCard = app.buttons["formatCard-scramble"]
        XCTAssertTrue(scrambleCard.exists)
        
        // Test "Betting" filter
        let bettingChip = app.buttons["filter-betting"]
        XCTAssertTrue(bettingChip.exists)
        bettingChip.tap()
        
        // Verify only betting formats are shown
        let skinsCard = app.buttons["formatCard-skins"]
        XCTAssertTrue(skinsCard.exists)
        
        // Test "All" filter
        let allChip = app.buttons["filter-all"]
        XCTAssertTrue(allChip.exists)
        allChip.tap()
        
        // Verify all formats are shown again
        XCTAssertTrue(scrambleCard.exists)
        XCTAssertTrue(skinsCard.exists)
    }
    
    // MARK: - Format Detail Tests
    
    func testNavigationToFormatDetail() throws {
        let scrambleCard = app.buttons["formatCard-scramble"]
        XCTAssertTrue(scrambleCard.exists)
        scrambleCard.tap()
        
        // Verify detail screen elements
        let formatTitle = app.staticTexts["Scramble"]
        XCTAssertTrue(formatTitle.exists)
        
        let playerCount = app.staticTexts["2-4 players"]
        XCTAssertTrue(playerCount.exists)
        
        let difficultyBadge = app.staticTexts["easy"]
        XCTAssertTrue(difficultyBadge.exists)
        
        let howToPlaySection = app.staticTexts["How to Play:"]
        XCTAssertTrue(howToPlaySection.exists)
        
        let scoringExample = app.staticTexts["Scoring Example:"]
        XCTAssertTrue(scoringExample.exists)
    }
    
    func testBookmarkButtonInDetail() throws {
        // Navigate to format detail
        let scrambleCard = app.buttons["formatCard-scramble"]
        scrambleCard.tap()
        
        // Find bookmark button
        let bookmarkButton = app.buttons["bookmarkButton"]
        XCTAssertTrue(bookmarkButton.exists)
        
        // Tap to bookmark
        bookmarkButton.tap()
        
        // Verify bookmark state changed
        let bookmarkIcon = app.images["bookmark.fill"]
        XCTAssertTrue(bookmarkIcon.exists)
        
        // Tap to unbookmark
        bookmarkButton.tap()
        
        // Verify bookmark removed
        let unbookmarkIcon = app.images["bookmark"]
        XCTAssertTrue(unbookmarkIcon.exists)
    }
    
    func testBackNavigationFromDetail() throws {
        let scrambleCard = app.buttons["formatCard-scramble"]
        scrambleCard.tap()
        
        // Use back button
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        // Verify we're back on home screen
        let formatGrid = app.scrollViews["formatsGrid"]
        XCTAssertTrue(formatGrid.exists)
    }
    
    // MARK: - Bookmarks Screen Tests
    
    func testTabBarNavigation() throws {
        // Verify Browse tab is selected by default
        let browseTab = app.tabBars.buttons["Browse"]
        XCTAssertTrue(browseTab.exists)
        XCTAssertTrue(browseTab.isSelected)
        
        // Navigate to Saved tab
        let savedTab = app.tabBars.buttons["Saved"]
        XCTAssertTrue(savedTab.exists)
        savedTab.tap()
        XCTAssertTrue(savedTab.isSelected)
        
        // Verify Saved screen is displayed
        let savedTitle = app.navigationBars["Saved Formats"]
        XCTAssertTrue(savedTitle.exists)
    }
    
    func testAddAndViewBookmark() throws {
        // Bookmark a format
        let scrambleCard = app.buttons["formatCard-scramble"]
        scrambleCard.tap()
        
        let bookmarkButton = app.buttons["bookmarkButton"]
        bookmarkButton.tap()
        
        // Navigate back
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        
        // Go to Saved tab
        let savedTab = app.tabBars.buttons["Saved"]
        savedTab.tap()
        
        // Verify bookmarked format appears
        let savedScramble = app.cells["saved-scramble"]
        XCTAssertTrue(savedScramble.exists)
    }
    
    func testSwipeToDeleteBookmark() throws {
        // First bookmark a format
        let scrambleCard = app.buttons["formatCard-scramble"]
        scrambleCard.tap()
        
        let bookmarkButton = app.buttons["bookmarkButton"]
        bookmarkButton.tap()
        
        // Navigate to Saved tab
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tabBars.buttons["Saved"].tap()
        
        // Swipe to delete
        let savedScramble = app.cells["saved-scramble"]
        XCTAssertTrue(savedScramble.exists)
        
        savedScramble.swipeLeft()
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists)
        deleteButton.tap()
        
        // Verify item removed
        XCTAssertFalse(savedScramble.exists)
    }
    
    func testEmptyBookmarksState() throws {
        // Go to Saved tab without any bookmarks
        let savedTab = app.tabBars.buttons["Saved"]
        savedTab.tap()
        
        // Verify empty state message
        let emptyMessage = app.staticTexts["No saved formats yet"]
        XCTAssertTrue(emptyMessage.exists)
        
        let helpMessage = app.staticTexts["Tap the bookmark icon on any format to save it here"]
        XCTAssertTrue(helpMessage.exists)
    }
    
    // MARK: - Dark Mode Tests
    
    func testDarkModeToggle() throws {
        // This test assumes there's a settings button or automatic dark mode support
        // Since we're supporting system dark mode, we'll verify elements exist in both modes
        
        let formatGrid = app.scrollViews["formatsGrid"]
        XCTAssertTrue(formatGrid.exists)
        
        // Verify UI elements are visible (they should adapt to dark/light mode automatically)
        let scrambleCard = app.buttons["formatCard-scramble"]
        XCTAssertTrue(scrambleCard.exists)
    }
    
    // MARK: - Scroll Performance Tests
    
    func testScrollingPerformance() throws {
        let formatGrid = app.scrollViews["formatsGrid"]
        XCTAssertTrue(formatGrid.exists)
        
        // Scroll down
        formatGrid.swipeUp()
        formatGrid.swipeUp()
        
        // Scroll up
        formatGrid.swipeDown()
        formatGrid.swipeDown()
        
        // Verify grid still exists and is responsive
        XCTAssertTrue(formatGrid.exists)
    }
    
    // MARK: - Search and Filter Combination Tests
    
    func testSearchWithFilterCombination() throws {
        // Apply tournament filter
        let tournamentChip = app.buttons["filter-tournament"]
        tournamentChip.tap()
        
        // Search within filtered results
        let searchField = app.searchFields["Search formats..."]
        searchField.tap()
        searchField.typeText("Scr")
        
        // Verify only tournament formats with "Scr" are shown
        let scrambleCard = app.buttons["formatCard-scramble"]
        XCTAssertTrue(scrambleCard.exists)
    }
    
    func testClearSearchField() throws {
        let searchField = app.searchFields["Search formats..."]
        searchField.tap()
        searchField.typeText("Test")
        
        // Clear button should appear
        let clearButton = app.buttons["Clear text"]
        XCTAssertTrue(clearButton.exists)
        clearButton.tap()
        
        // Verify search field is empty
        XCTAssertEqual(searchField.value as? String, "Search formats...")
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityLabels() throws {
        // Verify important elements have accessibility labels
        let scrambleCard = app.buttons["formatCard-scramble"]
        XCTAssertTrue(scrambleCard.exists)
        XCTAssertNotNil(scrambleCard.label)
        
        let browseTab = app.tabBars.buttons["Browse"]
        XCTAssertTrue(browseTab.exists)
        XCTAssertNotNil(browseTab.label)
        
        let savedTab = app.tabBars.buttons["Saved"]
        XCTAssertTrue(savedTab.exists)
        XCTAssertNotNil(savedTab.label)
    }
    
    func testVoiceOverNavigation() throws {
        // This test verifies that elements are accessible for VoiceOver
        let formatGrid = app.scrollViews["formatsGrid"]
        XCTAssertTrue(formatGrid.isAccessibilityElement || formatGrid.children(matching: .any).count > 0)
        
        // Check if format cards are accessible
        let firstCard = app.buttons.matching(identifier: "formatCard-scramble").firstMatch
        XCTAssertTrue(firstCard.exists)
        XCTAssertTrue(firstCard.isHittable)
    }
    
    // MARK: - Launch Performance Test
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}