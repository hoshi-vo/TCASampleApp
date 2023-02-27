import Dependencies

struct GitHubRepository {
    var fetchGitHubItems: @Sendable (String, Int) async throws -> GitHubItemsEntity
}

extension DependencyValues {
    var gitHubRepository: GitHubRepository {
        get { self[GitHubRepository.self] }
        set { self[GitHubRepository.self] = newValue }
    }
}
