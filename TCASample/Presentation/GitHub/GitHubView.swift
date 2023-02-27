import ComposableArchitecture
import SwiftUI

struct GitHubView: View {
    let store: StoreOf<GitHubReducer>

    init(store: StoreOf<GitHubReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                ForEachStore(
                    store.scope(
                        state: \.items,
                        action: GitHubReducer.Action.gitHubItem(id:action:)
                    ),
                    content: GitHubItemView.init(store:)
                )
            }
            .searchable(text: viewStore.binding(get: \.text, send: GitHubReducer.Action.textChange))
            .onSubmit(of: .search) { viewStore.send(.search) }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}
