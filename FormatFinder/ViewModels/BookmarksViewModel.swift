import SwiftUI
import Combine

class BookmarksViewModel: ObservableObject {
    @Published var bookmarkedIds: Set<String> = []
    
    private let manager = BookmarksManager()
    
    init() {
        bookmarkedIds = manager.bookmarkedIds
    }
    
    func addBookmark(formatId: String) {
        manager.addBookmark(formatId: formatId)
        bookmarkedIds = manager.bookmarkedIds
    }
    
    func removeBookmark(formatId: String) {
        manager.removeBookmark(formatId: formatId)
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
    
    func clearAllBookmarks() {
        manager.clearAllBookmarks()
        bookmarkedIds = manager.bookmarkedIds
    }
}