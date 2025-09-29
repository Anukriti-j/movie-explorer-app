import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Picker("Select theme", selection: $settingsViewModel.selectedTheme) {
                ForEach(Theme.allCases) { theme in
                    Text(theme.rawValue).tag(theme)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
