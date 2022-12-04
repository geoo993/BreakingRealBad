import SwiftUI

@main
struct BreakingRealBadApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Characters.ContentView(
                store: .init(
                    initialState: .init(),
                    reducer: Characters.reducer,
                    environment: .init(
                        repository: CharacterRepository(),
                        queue: .main
                    )
                )
            )
            .onChange(of: scenePhase) { _ in
                persistenceController.save()
            }
        }
    }
}
