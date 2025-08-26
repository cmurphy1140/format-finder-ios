import Foundation

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
    
    func addBookmark(formatId: String) {
        var ids = bookmarkedIds
        ids.insert(formatId)
        bookmarkedIds = ids
    }
    
    func removeBookmark(formatId: String) {
        var ids = bookmarkedIds
        ids.remove(formatId)
        bookmarkedIds = ids
    }
    
    func toggleBookmark(formatId: String) {
        if isBookmarked(formatId: formatId) {
            removeBookmark(formatId: formatId)
        } else {
            addBookmark(formatId: formatId)
        }
    }
    
    func isBookmarked(formatId: String) -> Bool {
        bookmarkedIds.contains(formatId)
    }
    
    func getBookmarkedFormats(from formats: [GolfFormat]) -> [GolfFormat] {
        formats.filter { bookmarkedIds.contains($0.id) }
    }
    
    func clearAllBookmarks() {
        bookmarkedIds = []
    }
}