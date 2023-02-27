import ComposableArchitecture
import SwiftUI

struct GitHubItemView: View {
    let store: StoreOf<GitHubItemReducer>
    private let viewStore: ViewStoreOf<GitHubItemReducer>

    init(store: StoreOf<GitHubItemReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewStore.name).font(.title)
            if let description = viewStore.description {
                Text(description).font(.body)
            }
            Text("★ \(viewStore.stargazersCount)").font(.body)
        }
        .onTapGesture { viewStore.send(.tapped) }
        .onAppear { viewStore.send(.onAppear(index: viewStore.index)) }
    }
}
