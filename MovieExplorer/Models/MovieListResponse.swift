import Foundation

struct MovieListResponse: Codable, Identifiable {
    var id = UUID()
    let movieList : [MovieSummary]
    
    enum CodingKeys: String, CodingKey {
        case movieList = "Search"
    }
}

struct MovieSummary: Codable, Identifiable {
    var id = UUID()
    let title: String
    let imdbID: String
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case poster = "Poster"
    }
}
