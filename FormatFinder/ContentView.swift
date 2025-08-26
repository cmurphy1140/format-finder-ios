import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .browse
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.browse.title, systemImage: Tab.browse.icon)
                }
                .tag(Tab.browse)
            
            BookmarksView()
                .tabItem {
                    Label(Tab.saved.title, systemImage: Tab.saved.icon)
                }
                .tag(Tab.saved)
        }
        .tint(Color(hex: "2E7D32"))
    }
}