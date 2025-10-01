
import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel
  
    init(context: NSManagedObjectContext) {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Picker("Category", selection: $homeViewModel.selectedCategory) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue.capitalized)//.tag(flavor)
                            .tag(category)
                    }
                }
                
                VStack {
                    if homeViewModel.isloading {
                        ProgressView("loading...")
                    } else {
                        List {
                            ForEach(homeViewModel.filteredMovies) { movie in
                                NavigationLink {
                                    DetailView(movie: movie)
                                } label: {
                                    ListRowView(movie: movie)
                                }
                            }
                            .onDelete { indexSet in
                                let moviesToDelete = indexSet.map { homeViewModel.moviesFromCore[$0] }
                                homeViewModel.deleteMovie(movies: moviesToDelete)
                            }
                        }
                    }
                }
                .searchable(text: $homeViewModel.searchMovie, prompt: "Search Movie")
                .navigationTitle("Movies")
                .refreshable {
                    print("list refresing request")
                    Task {
                        await homeViewModel.fetchMoviesFromAPI()
                    }
                }
                Spacer()
            }
            .onAppear {
                homeViewModel.checkAndfetchMovie()
            }
        }
    }
}

#Preview {
    HomeView(context: CoreDataManager.shared.persistentContainer.viewContext)
}

