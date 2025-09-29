import Foundation

enum TabSelection: String, CaseIterable, Identifiable {
    case Home, Favourites, Settings
    
    var id: String { self.rawValue }
    
    var tabItemLabel: String {
        switch self {
        case .Home:
            return "Home"
        case .Favourites:
            return "Favourites"
        case .Settings:
            return "Settings"
        }
    }
    
    var tabImage: String {
        switch self {
        case .Home:
            return "house"
        case .Favourites:
            return "heart"
        case .Settings:
            return "gear"
        }
    }
}
