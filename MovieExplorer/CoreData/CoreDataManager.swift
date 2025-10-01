import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores { _, error in
            if let error = error {
                debugPrint("\(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                print("data saved in core")
            } catch {
                print("failed to save context: \(error)")
                print("cannot save data to core")
            }
        }
    }
    
    private init() {}
}
