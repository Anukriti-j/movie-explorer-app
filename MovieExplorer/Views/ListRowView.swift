import SwiftUI
import Kingfisher
import CoreData

struct ListRowView: View {
    var movie: Movie
    
    var body: some View {
        HStack {
            if let imageUrl = movie.poster, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder({
                        ProgressView()
                    })
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            Text(movie.title ?? "Not found")
        }
    }
}

//
//#Preview {
//    ListRowView()
//}
