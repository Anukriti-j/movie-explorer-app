import Foundation

final class APIService {
    static let service = APIService()
    
    private init() {}
    
    func getData<T: Codable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkErrors.invalidURL
            
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkErrors.decodingError
            }
        } else {
            throw NetworkErrors.invalidResponse
        }
    }
}

