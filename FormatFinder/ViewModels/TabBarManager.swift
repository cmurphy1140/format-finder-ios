import SwiftUI

class TabBarManager: ObservableObject {
    @Published var selectedTab: AppTab = .browse
}