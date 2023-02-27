import Foundation
import ComposableArchitecture

struct GitHubItemReducer: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: Int { index }
        let index: Int
        let name: String
        let fullName: String
        let description: String?
        let stargazersCount: Int
        let htmlUrl: URL
    }

    enum Action: Equatable {
        case onAppear(index: Int)
        case tapped
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return .none
        case .tapped:
            return .none
        }
    }
}
