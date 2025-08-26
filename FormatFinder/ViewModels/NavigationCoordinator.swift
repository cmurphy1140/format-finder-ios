import SwiftUI

class NavigationCoordinator: ObservableObject {
    enum NavigationView: Equatable {
        case home
        case detail(GolfFormat)
        case saved
        
        static func == (lhs: NavigationView, rhs: NavigationView) -> Bool {
            switch (lhs, rhs) {
            case (.home, .home), (.saved, .saved):
                return true
            case let (.detail(format1), .detail(format2)):
                return format1.id == format2.id
            default:
                return false
            }
        }
    }
    
    @Published var currentView: NavigationView = .home
    @Published var navigationPath = NavigationPath()
    
    func navigateToDetail(format: GolfFormat) {
        currentView = .detail(format)
        navigationPath.append(format)
    }
    
    func navigateToHome() {
        currentView = .home
        navigationPath.removeLast(navigationPath.count)
    }
    
    func navigateToSaved() {
        currentView = .saved
    }
}