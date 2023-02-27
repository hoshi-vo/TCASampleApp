import ComposableArchitecture

struct RootReducer: ReducerProtocol {
    struct State: Equatable {
        var gitHub = GitHubReducer.State()
    }

    enum Action {
        case onAppear
        case gitHub(GitHubReducer.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state = .init()
                return .none

            default:
                return .none
            }
        }
        Scope(state: \.gitHub, action: /Action.gitHub) {
            GitHubReducer()
        }
    }
}
