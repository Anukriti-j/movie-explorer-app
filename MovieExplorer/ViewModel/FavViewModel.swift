
import Foundation
import CoreData

class FavViewModel: ObservableObject {
    
    func deleteFromFavourites(movie: Movie, context: NSManagedObjectContext) {
        movie.isFav = false
        CoreDataManager.shared.saveContext(context: context)
    }
}
