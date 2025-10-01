import Foundation

enum Category: String, CaseIterable, Identifiable {
    case batman = "batman"
    case spiderman = "spiderman"
    case love = "love"
    case animal = "animal"
    case magic = "magic"
    
    var id: String { self.rawValue }
}
