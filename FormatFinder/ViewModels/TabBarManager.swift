import SwiftUI

class TabBarManager: ObservableObject {
    @Published var selectedTab: Tab = .browse
}