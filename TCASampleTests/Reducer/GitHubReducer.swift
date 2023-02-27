import ComposableArchitecture
import XCTest
@testable import TCASample

@MainActor
final class GitHubReducerTests: XCTestCase {
    private let responseEntity: GitHubItemsEntity = .init(items: [.mock, .mock, .mock, .mock, .mock])
    private func createItems(responseItems: [GitHubItemEntity],
                             currentItems: IdentifiedArrayOf<GitHubItemReducer.State> = []) -> IdentifiedArrayOf<GitHubItemReducer.State> {
        let items: [GitHubItemReducer.State] = responseItems.enumerated().map {
            .init(
                index: $0.offset + currentItems.count,
                name: $0.element.name,
                fullName: $0.element.fullName,
                description: $0.element.description,
                stargazersCount: $0.element.stargazersCount,
                htmlUrl: $0.element.htmlUrl
            )
        }
        return currentItems + items
    }

    func testOnAppear() async {
        let store = TestStore(
            initialState: GitHubReducer.State(),
            reducer: GitHubReducer()
        ) {
            $0.gitHubRepository = .init(
                fetchGitHubItems: { _,_ in self.responseEntity }
            )
        }
        await store.send(.onAppear)
        await store.receive(.fetchItemsResponse(.success(responseEntity))) { [self] in
            $0.items = createItems(responseItems: responseEntity.items, currentItems: $0.items)
        }
    }

    func testTextChange() async {
        let store = TestStore(
            initialState: GitHubReducer.State(),
            reducer: GitHubReducer()
        )
        await store.send(.textChange("Test")) {
            $0.text = "Test"
        }
    }

    func testSearch() async {
        let store = TestStore(
            initialState: GitHubReducer.State(
                text: "Test",
                page: 2,
                items: createItems(responseItems: responseEntity.items)),
            reducer: GitHubReducer()
        ) {
            $0.gitHubRepository = .init(
                fetchGitHubItems: { _,_ in self.responseEntity }
            )
        }
        await store.send(.search) {
            $0.key = "Test"
        }
        await store.receive(.refresh) {
            $0.items = []
            $0.page = 1
        }
        await store.receive(.fetchItemsResponse(.success(responseEntity))) { [self] in
            $0.items = createItems(responseItems: responseEntity.items, currentItems: $0.items)
        }
    }

    func testGitHubItemOnAppearDoNotLoadNext() async {
        let store = TestStore(
            initialState: GitHubReducer.State(
                items: createItems(responseItems: responseEntity.items)),
            reducer: GitHubReducer()
        ) {
            $0.gitHubRepository = .init(
                fetchGitHubItems: { _,_ in self.responseEntity }
            )
        }
        await store.send(.gitHubItem(id: .zero, action: .onAppear(index: 3)))
    }

    func testGitHubItemOnAppearLoadNext() async {
        let store = TestStore(
            initialState: GitHubReducer.State(
                items: createItems(responseItems: responseEntity.items)),
            reducer: GitHubReducer()
        ) {
            $0.gitHubRepository = .init(
                fetchGitHubItems: { _,_ in self.responseEntity }
            )
        }
        await store.send(.gitHubItem(id: .zero, action: .onAppear(index: 4))) {
            $0.page = 2
        }
        await store.receive(.fetchItemsResponse(.success(responseEntity))) { [self] in
            $0.items = createItems(responseItems: responseEntity.items, currentItems: $0.items)
        }
    }
}
