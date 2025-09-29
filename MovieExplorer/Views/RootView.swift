
import SwiftUI
import CoreData

struct RootView: View {
    @Environment(\.managedObjectContext) var context
    var body: some View {
        TabView {
            ForEach(TabSelection.allCases) { tab in
                tabView(tab: tab, context: context)
                    .tabItem {
                        Label(tab.tabItemLabel, systemImage: tab.tabImage)
                    }.tag(tab)
            }
        }
    }
}

@ViewBuilder
func tabView(tab: TabSelection, context: NSManagedObjectContext) -> some View {
    switch tab {
    case .Home:
        HomeView(context: context)
    case .Favourites:
        FavView()
    case .Settings:
        SettingsView()
    }
}

#Preview {
    RootView()
}
