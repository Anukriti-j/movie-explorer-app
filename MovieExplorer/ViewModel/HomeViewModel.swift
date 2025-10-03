import Foundation
import SwiftUI
import CoreData

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published private var moviesFromAPI: [MovieSummary] = []
    @Published var moviesFromCore: [Movie] = []
    @Published var isloading: Bool = false
    @Published var context: NSManagedObjectContext
    @Published var loadedDataFromAPI: Bool = false
    @Published var selectedCategory: Category = .batman {
        didSet {
            print("category changes fetch called")
            checkAndfetchMovie()
        }
    }
    
    var response: MovieListResponse = MovieListResponse(movieList: [])
    @Published var searchMovie: String = "" {
        didSet {
            filteredMovies = filterMovies()
        }
    }
    @Published var filteredMovies: [Movie] = []

    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchMoviesFromAPI() async {
            isloading = true
            let searchURL = Constants.baseURL + "&s=\(selectedCategory.rawValue)"
            do {
                response = try await APIService.service.getData(urlString: searchURL)
                moviesFromAPI = response.movieList
                print("get data from api")
            } catch {
                print("error fetching data from API: \(error.localizedDescription)")
            }
            Task {
                await saveMoviesToCore()
            }
    }
    
    func checkAndfetchMovie() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", selectedCategory.rawValue)
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                Task {
                    await fetchMoviesFromAPI()
                }
            } else {
                fetchFromCore()
            }
        } catch {
            print("Error fetching data from Core: \(error)")
        }
    }
    
    func saveMoviesToCore() async {
        do {
            try await context.perform {
                for movieSummary in self.moviesFromAPI {
                    let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "imdb == %@", movieSummary.imdbID)
                    
                    if let existing = try self.context.fetch(fetchRequest).first {
                        existing.title = movieSummary.title
                        existing.poster = movieSummary.poster
                        existing.detailFetched = false
                        existing.category = self.selectedCategory.rawValue
                    } else {
                        let newMovie = Movie(context: self.context)
                        newMovie.imdb = movieSummary.imdbID
                        newMovie.title = movieSummary.title
                        newMovie.poster = movieSummary.poster
                        newMovie.detailFetched = false
                        newMovie.category = self.selectedCategory.rawValue
                    }
                }
            }
            CoreDataManager.shared.saveContext(context: self.context)
            self.fetchFromCore()
        } catch {
            print("\(error)")
        }
        isloading = false
    }

    func fetchFromCore() {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Movie.title, ascending: true)]
        request.predicate = NSPredicate(format: "category = %@", self.selectedCategory.rawValue)
      
        do {
            moviesFromCore = try context.fetch(request)
            filteredMovies = filterMovies()
            print("print fetched movies from core in function")
        } catch {
            print("fetch from core failed: \(error.localizedDescription)")
        }
    }
    
    func deleteMovie(movies: [Movie]) {
        for movie in movies {
            context.delete(movie)
        }
        CoreDataManager.shared.saveContext(context: context)
    }

    func filterMovies() -> [Movie] {
        if searchMovie.isEmpty {
            return Array(moviesFromCore)
        } else {
            return moviesFromCore.filter { movie in
                movie.title?.localizedCaseInsensitiveContains(searchMovie) ?? false
            }
        }
    }
}



// refresh = api call
// view appear = fetch from core if exist/ api call - wiht selected Category


// movieexist func ke andr api call ka function
// refreh me direct api call ka function
