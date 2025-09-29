import Foundation
import SwiftUICore

class SettingsViewModel: ObservableObject {
    @Published var selectedTheme: Theme = .system {
        didSet {
            saveTheme()
        }
    }
    
    init() {
        if let theme = UserDefaults.standard.string(forKey: "theme") {
            self.selectedTheme = Theme(rawValue: theme) ?? .system
        } else {
            self.selectedTheme = .system
        }
    }
    
    private func saveTheme() {
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "theme")
    }
    
    var colorScheme: ColorScheme {
        switch selectedTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .light
        }
    }
}
