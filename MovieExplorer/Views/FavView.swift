import SwiftUI
import CoreData

struct FavView: View {
    @StateObject private var favViewModel: FavViewModel = FavViewModel()
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Movie.released, ascending: false)],
        predicate: NSPredicate(format: "isFav == %@", NSNumber(value: true)),
        animation: .default)
    private var fetchedFavMovies: FetchedResults<Movie>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fetchedFavMovies) { movie in
                    ListRowView(movie: movie)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let movieToRemove = fetchedFavMovies[index]
                        favViewModel.deleteFromFavourites(movie: movieToRemove, context: context)
                    }
                }
            }
            .navigationTitle("Favourites")
        }
    }
}


