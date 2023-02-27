import Foundation

struct GitHubItemEntity: Decodable, Equatable {
    var name: String
    var fullName: String
    var description: String?
    var stargazersCount: Int
    var htmlUrl: URL

    init(name: String, fullName: String, description: String?, stargazersCount: Int, htmlUrl: URL) {
        self.name = name
        self.fullName = fullName
        self.description = description
        self.stargazersCount = stargazersCount
        self.htmlUrl = htmlUrl
    }
}
