
import Foundation

struct MovieAPIitem: Codable, Identifiable {
    var id: String
    let title, rated, released: String?
    let genre: String?
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case rated = "Rated"
        case released = "Released"
        case genre = "Genre"
        case poster = "Poster"
        case id = "imdbID"
    }
}
extension MovieAPIitem {
    init(from movie: Movie) {
        self.title = movie.title ?? ""
        self.rated = movie.rated
        self.released = movie.released
        self.genre = movie.genre
        self.id = movie.imdb ?? ""
        self.poster = movie.poster
    }
}



