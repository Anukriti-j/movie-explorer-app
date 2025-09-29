import Foundation
import CoreData

@MainActor
class DetailViewModel: ObservableObject {
    
    var context: NSManagedObjectContext
    @Published var movieItem: MovieAPIitem? = nil
    @Published var isLoadingDetail: Bool = true
    @Published var markFav: Bool
    private var movie: Movie
    
    init(context: NSManagedObjectContext, movie: Movie) {
        self.context = context
        self.movie = movie
        self.markFav = movie.isFav
    }
    
    func getDetailData(id: String) async {
        isLoadingDetail = true
        defer { isLoadingDetail = false }
        
        do {
            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "imdb == %@", id)
            fetchRequest.fetchLimit = 1
            
            if let existingMovie = try context.fetch(fetchRequest).first {
                if existingMovie.detailFetched {
                    print("Loaded from Core Data")
                    self.movieItem = MovieAPIitem(from: existingMovie)
                    return  
                }
                
                if let fetchedDetail: MovieAPIitem = try await APIService.service.getData(
                    urlString: "http://www.omdbapi.com/?i=\(id)&apikey=f034da63"
                ) {
                    existingMovie.rated = fetchedDetail.rated
                    existingMovie.released = fetchedDetail.released
                    existingMovie.genre = fetchedDetail.genre
                    existingMovie.detailFetched = true
                    
                    CoreDataManager.shared.saveContext(context: context)
                    self.movieItem = fetchedDetail
                    print("Movie detail updated and saved.")
                    
                } else {
                    print("API returned nil")
                }
            } else {
                print("No movie found in Core Data with id: \(id)")
            }
        } catch {
            print("Error fetching detail: \(error.localizedDescription)")
        }
    }
    
    func toggleFavourite(id: String) {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdb == %@", id)
        fetchRequest.fetchLimit = 1
        
        do {
            if let existingMovie = try context.fetch(fetchRequest).first {
                existingMovie.isFav.toggle()
                CoreDataManager.shared.saveContext(context: context)
                self.markFav = existingMovie.isFav
            }
        } catch {
            print("Error toggling favourites: \(error)")
        }
    }
}
