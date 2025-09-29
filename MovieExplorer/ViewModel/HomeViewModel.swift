import Foundation
import SwiftUI
import CoreData

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var moviesFromCore: [Movie] = []
    @Published var isloading: Bool = true
    @Published var context: NSManagedObjectContext
    @Published var movies: Any? = nil
    @Published var loadedDataFromAPI: Bool = false
    var response: MovieListResponse = MovieListResponse(movieList: [])
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAndSaveMovies() async {
        isloading = true
        do {
            response = try await APIService.service.getData(urlString: Constants.baseURL)
            print("get data from api")
            let moviesFromAPI = response.movieList
            
            try await context.perform {
                for movieSummary in moviesFromAPI {
                    let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "imdb == %@", movieSummary.imdbID)
                    
                    if let existing = try self.context.fetch(fetchRequest).first {
                        existing.title = movieSummary.title
                        existing.poster = movieSummary.poster
                        existing.detailFetched = false
                    } else {
                        let newMovie = Movie(context: self.context)
                        newMovie.imdb = movieSummary.imdbID
                        newMovie.title = movieSummary.title
                        newMovie.poster = movieSummary.poster
                        newMovie.detailFetched = false
                    }
                }
                try self.context.save()
            }
            loadedDataFromAPI = true
        } catch {
            print("error: \(error.localizedDescription)")
        }
        isloading = false
    }
    
    
    func deleteMovie(movies: [Movie]) {
        for movie in movies {
            context.delete(movie)
        }
        CoreDataManager.shared.saveContext(context: context)
    }
    
}
