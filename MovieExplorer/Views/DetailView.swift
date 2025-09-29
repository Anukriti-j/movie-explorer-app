import SwiftUI
import Kingfisher
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var context
    @StateObject var detailViewModel: DetailViewModel
    @State var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        _detailViewModel = StateObject(wrappedValue: DetailViewModel(context: CoreDataManager.shared.persistentContainer.viewContext, movie: movie))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                if detailViewModel.isLoadingDetail {
                    ProgressView("Loading Details...")
                } else {
                    Text(detailViewModel.movieItem?.title ?? "Not found")
                        .font(.headline)
                        .padding()
                    
                    if let imageURL = detailViewModel.movieItem?.poster, let url = URL(string: imageURL) {
                        KFImage(url)
                            .placeholder({
                                ProgressView()
                            })
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding()
                    }
                    
                    HStack {
                        Text("Release Date:")
                            .font(.headline)
                        Text(detailViewModel.movieItem?.released ?? "Not found")
                    }
                    
                    HStack {
                        Text("Category:")
                            .font(.headline)
                        Text(detailViewModel.movieItem?.genre ?? "Not found")
                    }
                    
                    HStack {
                        Text("Rated:")
                            .font(.headline)
                        Text(detailViewModel.movieItem?.rated ?? "no rating found")
                    }
                }
            }
            .onAppear(perform: {
                Task {
                    if let id = movie.imdb {
                        await detailViewModel.getDetailData(id: id)
                    }
                }
            })
            .padding()
            .toolbar {
                Button {
                    if let id = movie.imdb {
                        detailViewModel.toggleFavourite(id: id)
                    }
                } label: {
                    Image(systemName: (detailViewModel.markFav ? "heart.fill": "heart"))
                        .padding()
                }
            }
        }
    }
}

//#Preview {
//    DetailView()
//}
