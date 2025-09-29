import SwiftUI
import CoreData

@main
struct MovieExplorerApp: App {
    let coreDataManager = CoreDataManager.shared
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, coreDataManager.persistentContainer.viewContext)
                .environmentObject(settingsViewModel)
                .preferredColorScheme(settingsViewModel.colorScheme)
            
        }
    }
}
