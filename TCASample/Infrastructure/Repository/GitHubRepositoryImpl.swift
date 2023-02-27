import Dependencies

extension GitHubRepository {
    static func live(httpClient: HTTPClient) -> Self {
        .init(
            fetchGitHubItems: { try await httpClient.request(key: $0, page: $1) }
        )
    }
}

extension GitHubRepository: DependencyKey {
    static let liveValue: Self = .live(httpClient: HTTPClient())
}
