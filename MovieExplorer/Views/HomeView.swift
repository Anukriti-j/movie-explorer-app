
import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel
    @State private var searchMovie: String = ""
    
    init(context: NSManagedObjectContext) {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(context: context))
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Movie.released, ascending: false)],
        animation: .default
    )
    private var fetchedMovies: FetchedResults<Movie>
    
    private var filteredMovies: [Movie] {
        if searchMovie.isEmpty {
            return Array(fetchedMovies)
        } else {
            return fetchedMovies.filter { movie in
                movie.title?.localizedCaseInsensitiveContains(searchMovie) ?? false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            
            if homeViewModel.isloading {
                ProgressView("loading...")
            } else {
                List {
                    
                    ForEach(filteredMovies) { movie in
                        NavigationLink {
                            // TODO: Why navigation link is getting called even not interacted with cell.
                            DetailView(movie: movie)
                        } label: {
                            ListRowView(movie: movie)
                        }
                    }
                    .onDelete { indexSet in
                        let moviesToDelete = indexSet.map { fetchedMovies[$0] }
                        homeViewModel.deleteMovie(movies: moviesToDelete)
                    }
                }
                .searchable(text: $searchMovie, prompt: "Search Movie")
                .navigationTitle("Movies")
                .refreshable {
                    Task {
                        await homeViewModel.fetchAndSaveMovies()
                    }
                }
            }
        }
        .onAppear {
            if homeViewModel.loadedDataFromAPI == false {
                Task {
                    await homeViewModel.fetchAndSaveMovies()
                }
            }
        }
    }
}
//
//#Preview {
//    HomeView()
//}
