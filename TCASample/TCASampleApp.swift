import ComposableArchitecture
import SwiftUI

@main
struct TCASampleApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: RootReducer.State(),
                    reducer: RootReducer()
                )
            )
        }
    }
}
