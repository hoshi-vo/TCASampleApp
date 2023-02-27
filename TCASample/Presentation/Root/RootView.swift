import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<RootReducer>
    private let viewStore: ViewStoreOf<RootReducer>

    init(store: StoreOf<RootReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store)
    }

    var body: some View {
        NavigationView {
            Form {
                NavigationLink(
                    "GitHubView",
                    destination: GitHubView(
                        store: self.store.scope(
                            state: \.gitHub,
                            action: RootReducer.Action.gitHub
                        )
                    )
                )
            }
            .navigationTitle("RootView")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: Store(
                initialState: RootReducer.State(),
                reducer: RootReducer()
            )
        )
    }
}
