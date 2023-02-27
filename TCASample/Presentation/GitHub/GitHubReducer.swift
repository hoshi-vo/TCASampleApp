import ComposableArchitecture

struct GitHubReducer: ReducerProtocol {
    struct State: Equatable {
        var text = "GitHub"
        var key = "GitHub"
        var page = 1
        var items = IdentifiedArrayOf<GitHubItemReducer.State>()
    }

    enum Action: Equatable {
        case onAppear
        case textChange(String)
        case search
        case refresh
        case fetchItemsResponse(TaskResult<GitHubItemsEntity>)
        case gitHubItem(id: GitHubItemReducer.State.ID, action: GitHubItemReducer.Action)
    }

    @Dependency(\.gitHubRepository) var gitHubRepository

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return fetchItems(state: state)

            case .textChange(let text):
                state.text = text
                return .none

            case .search:
                state.key = state.text
                return EffectTask(value: .refresh)

            case .refresh:
                state.items = []
                state.page = 1
                return fetchItems(state: state)

            case .fetchItemsResponse(let response):
                switch response {
                case .success(let entity):
                    appendItems(items: entity.items, state: &state)
                    return .none

                case .failure:
                    return .none
                }

            case .gitHubItem(_, let action):
                switch action {
                case .onAppear(let index):
                    if index == state.items.count - 1 {
                        return fetchNextItems(state: &state)
                    }
                    return .none

                case .tapped:
                    return .none
                }
            }
        }
        .forEach(\.items, action: /Action.gitHubItem(id:action:)) {
            GitHubItemReducer()
        }
    }

    func fetchNextItems(state: inout State) -> EffectTask<Action> {
        state.page += 1
        return fetchItems(state: state)
    }

    func fetchItems(state: State) -> EffectTask<Action> {
        return .task { [key = state.key, page = state.page] in
            await .fetchItemsResponse(TaskResult { try await self.gitHubRepository.fetchGitHubItems(key, page) })
        }
    }

    func appendItems(items: [GitHubItemEntity], state: inout State) {
        let items: [GitHubItemReducer.State] = items.enumerated().map {
            .init(
                index: $0.offset + state.items.count,
                name: $0.element.name,
                fullName: $0.element.fullName,
                description: $0.element.description,
                stargazersCount: $0.element.stargazersCount,
                htmlUrl: $0.element.htmlUrl
            )
        }
        state.items += items
    }
}
