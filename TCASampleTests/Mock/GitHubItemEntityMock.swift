import Foundation
@testable import TCASample

extension GitHubItemEntity {
    static let mock: Self = .init(
        name: "TestName",
        fullName: "TestFullName",
        description: "Description",
        stargazersCount: 100,
        htmlUrl: URL(string: "https://www.google.com/")!
    )
}
