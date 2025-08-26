import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .browse
    @Published var selectedFormat: GolfFormat?
    
    let formatsViewModel = FormatsViewModel()
    let bookmarksViewModel = BookmarksViewModel()
    
    func navigateToFormat(_ format: GolfFormat) {
        selectedFormat = format
    }
    
    func clearSelection() {
        selectedFormat = nil
    }
}