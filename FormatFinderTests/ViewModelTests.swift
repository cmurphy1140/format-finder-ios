import XCTest
import Combine
@testable import FormatFinder

final class ViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - FormatsViewModel Tests
    
    func testFormatsViewModelPublishedProperties() {
        let viewModel = FormatsViewModel()
        
        let expectation = XCTestExpectation(description: "Published properties update")
        
        viewModel.$searchText
            .sink { searchText in
                if searchText == "Test" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "Test"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFormatsViewModelLoadFormats() {
        let viewModel = FormatsViewModel()
        
        XCTAssertFalse(viewModel.formats.isEmpty)
        XCTAssertEqual(viewModel.formats.count, 10)
        
        // Verify all required formats are loaded
        let formatIds = viewModel.formats.map { $0.id }
        XCTAssertTrue(formatIds.contains("scramble"))
        XCTAssertTrue(formatIds.contains("best-ball"))
        XCTAssertTrue(formatIds.contains("alternate-shot"))
        XCTAssertTrue(formatIds.contains("stableford"))
        XCTAssertTrue(formatIds.contains("match-play"))
        XCTAssertTrue(formatIds.contains("skins"))
        XCTAssertTrue(formatIds.contains("nassau"))
        XCTAssertTrue(formatIds.contains("wolf"))
        XCTAssertTrue(formatIds.contains("shamble"))
        XCTAssertTrue(formatIds.contains("chapman"))
    }
    
    func testFormatsViewModelFilteredFormatsReactive() {
        let viewModel = FormatsViewModel()
        let expectation = XCTestExpectation(description: "Filtered formats update")
        
        viewModel.$searchText
            .combineLatest(viewModel.$selectedFilter)
            .map { _, _ in viewModel.filteredFormats }
            .sink { formats in
                if formats.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "Scramble"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFormatsViewModelResetFilters() {
        let viewModel = FormatsViewModel()
        
        viewModel.searchText = "Test"
        viewModel.selectedFilter = .betting
        
        viewModel.resetFilters()
        
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertEqual(viewModel.selectedFilter, .all)
    }
    
    func testFormatsViewModelFormatById() {
        let viewModel = FormatsViewModel()
        
        let scramble = viewModel.format(by: "scramble")
        XCTAssertNotNil(scramble)
        XCTAssertEqual(scramble?.name, "Scramble")
        
        let nonExistent = viewModel.format(by: "non-existent-id")
        XCTAssertNil(nonExistent)
    }
    
    // MARK: - BookmarksViewModel Tests
    
    func testBookmarksViewModelAddRemove() {
        let viewModel = BookmarksViewModel()
        
        viewModel.addBookmark(formatId: "scramble")
        XCTAssertTrue(viewModel.isBookmarked(formatId: "scramble"))
        XCTAssertEqual(viewModel.bookmarkedIds.count, 1)
        
        viewModel.removeBookmark(formatId: "scramble")
        XCTAssertFalse(viewModel.isBookmarked(formatId: "scramble"))
        XCTAssertEqual(viewModel.bookmarkedIds.count, 0)
    }
    
    func testBookmarksViewModelToggle() {
        let viewModel = BookmarksViewModel()
        
        XCTAssertFalse(viewModel.isBookmarked(formatId: "scramble"))
        
        viewModel.toggleBookmark(formatId: "scramble")
        XCTAssertTrue(viewModel.isBookmarked(formatId: "scramble"))
        
        viewModel.toggleBookmark(formatId: "scramble")
        XCTAssertFalse(viewModel.isBookmarked(formatId: "scramble"))
    }
    
    func testBookmarksViewModelPublishedUpdates() {
        let viewModel = BookmarksViewModel()
        let expectation = XCTestExpectation(description: "Bookmarks update")
        
        viewModel.$bookmarkedIds
            .dropFirst() // Skip initial value
            .sink { ids in
                if ids.contains("scramble") {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.addBookmark(formatId: "scramble")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testBookmarksViewModelGetFormats() {
        let bookmarksVM = BookmarksViewModel()
        let formatsVM = FormatsViewModel()
        
        bookmarksVM.addBookmark(formatId: "scramble")
        bookmarksVM.addBookmark(formatId: "best-ball")
        
        let bookmarkedFormats = bookmarksVM.getBookmarkedFormats(from: formatsVM.formats)
        
        XCTAssertEqual(bookmarkedFormats.count, 2)
        XCTAssertTrue(bookmarkedFormats.contains(where: { $0.id == "scramble" }))
        XCTAssertTrue(bookmarkedFormats.contains(where: { $0.id == "best-ball" }))
    }
    
    func testBookmarksViewModelClearAll() {
        let viewModel = BookmarksViewModel()
        
        viewModel.addBookmark(formatId: "scramble")
        viewModel.addBookmark(formatId: "best-ball")
        viewModel.addBookmark(formatId: "skins")
        
        XCTAssertEqual(viewModel.bookmarkedIds.count, 3)
        
        viewModel.clearAllBookmarks()
        
        XCTAssertEqual(viewModel.bookmarkedIds.count, 0)
        XCTAssertFalse(viewModel.isBookmarked(formatId: "scramble"))
        XCTAssertFalse(viewModel.isBookmarked(formatId: "best-ball"))
        XCTAssertFalse(viewModel.isBookmarked(formatId: "skins"))
    }
    
    // MARK: - MainViewModel Tests
    
    func testMainViewModelInitialization() {
        let viewModel = MainViewModel()
        
        XCTAssertNotNil(viewModel.formatsViewModel)
        XCTAssertNotNil(viewModel.bookmarksViewModel)
        XCTAssertEqual(viewModel.selectedTab, .browse)
    }
    
    func testMainViewModelTabSelection() {
        let viewModel = MainViewModel()
        let expectation = XCTestExpectation(description: "Tab selection update")
        
        viewModel.$selectedTab
            .sink { tab in
                if tab == .saved {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.selectedTab = .saved
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMainViewModelNavigateToFormat() {
        let viewModel = MainViewModel()
        
        let format = viewModel.formatsViewModel.formats.first!
        viewModel.navigateToFormat(format)
        
        XCTAssertEqual(viewModel.selectedFormat?.id, format.id)
    }
    
    func testMainViewModelClearSelection() {
        let viewModel = MainViewModel()
        
        let format = viewModel.formatsViewModel.formats.first!
        viewModel.navigateToFormat(format)
        XCTAssertNotNil(viewModel.selectedFormat)
        
        viewModel.clearSelection()
        XCTAssertNil(viewModel.selectedFormat)
    }
    
    // MARK: - Search Debouncing Tests
    
    func testSearchDebouncingBehavior() {
        let viewModel = FormatsViewModel()
        let expectation = XCTestExpectation(description: "Debounced search")
        expectation.expectedFulfillmentCount = 1 // Should only trigger once despite multiple updates
        
        var updateCount = 0
        
        viewModel.$searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { _ in
                updateCount += 1
                if updateCount == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Rapid updates
        viewModel.searchText = "S"
        viewModel.searchText = "Sc"
        viewModel.searchText = "Scr"
        viewModel.searchText = "Scra"
        viewModel.searchText = "Scramble"
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(updateCount, 1)
    }
    
    // MARK: - Combine Pipeline Tests
    
    func testCombineFilteringPipeline() {
        let viewModel = FormatsViewModel()
        let expectation = XCTestExpectation(description: "Combined filtering")
        
        Publishers.CombineLatest(viewModel.$searchText, viewModel.$selectedFilter)
            .map { searchText, filter in
                viewModel.formats.filter { format in
                    let matchesSearch = searchText.isEmpty || format.matchesSearchText(searchText)
                    let matchesFilter = filter == .all || format.belongsToCategory(filter)
                    return matchesSearch && matchesFilter
                }
            }
            .sink { filtered in
                if filtered.count == 1 && filtered[0].id == "scramble" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.selectedFilter = .tournament
        viewModel.searchText = "Scramble"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - State Management Tests
    
    func testViewModelStateConsistency() {
        let viewModel = FormatsViewModel()
        
        // Initial state
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertEqual(viewModel.selectedFilter, .all)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        
        // Simulate loading
        viewModel.isLoading = true
        XCTAssertTrue(viewModel.isLoading)
        
        // Simulate error
        viewModel.errorMessage = "Test error"
        viewModel.isLoading = false
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Test error")
        
        // Clear error
        viewModel.errorMessage = nil
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Memory Management Tests
    
    func testViewModelMemoryManagement() {
        weak var weakViewModel: FormatsViewModel?
        
        autoreleasepool {
            let viewModel = FormatsViewModel()
            weakViewModel = viewModel
            XCTAssertNotNil(weakViewModel)
        }
        
        XCTAssertNil(weakViewModel)
    }
    
    func testCancellableCleanup() {
        let viewModel = FormatsViewModel()
        var localCancellables = Set<AnyCancellable>()
        
        viewModel.$searchText
            .sink { _ in }
            .store(in: &localCancellables)
        
        XCTAssertEqual(localCancellables.count, 1)
        
        localCancellables.removeAll()
        XCTAssertEqual(localCancellables.count, 0)
    }
}