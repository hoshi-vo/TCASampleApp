import Foundation
import Combine

// ここの実装は手抜き
struct HTTPClient {
    func request(key: String, page: Int) -> AnyPublisher<GitHubItemsEntity, APIError> {
        let encodeKey = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let urlString = "https://api.github.com/search/repositories?q=\(encodeKey)&page=\(page)&per_page=15"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, response in data }
            .decode(type: GitHubItemsEntity.self, decoder: jsonDecoder)
            .mapError { error in .unknown(error) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func _request(key: String, page: Int) async throws -> GitHubItemsEntity {
        let encodeKey = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let urlString = "https://api.github.com/search/repositories?q=\(encodeKey)&page=\(page)&per_page=15"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) {data, _ ,_ in
                guard let data = data else {
                    continuation.resume(throwing: APIError.unknown(nil))
                    return
                }
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let items = try jsonDecoder.decode(GitHubItemsEntity.self, from: data)
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: APIError.unknown(error))
                }
            }
        }
    }

    func request(key: String, page: Int) async throws -> GitHubItemsEntity {
        let encodeKey = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let urlString = "https://api.github.com/search/repositories?q=\(encodeKey)&page=\(page)&per_page=15"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        do {
            let data = (try await URLSession.shared.data(for: request)).0
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            return try jsonDecoder.decode(GitHubItemsEntity.self, from: data)
        } catch {
            throw APIError.unknown(error)
        }
    }
}

enum APIError: Error {
    case unknown(Error?)
}
