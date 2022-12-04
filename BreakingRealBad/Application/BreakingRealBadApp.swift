import SwiftUI
import ComposableArchitecture

@main
struct BreakingRealBadApp: App {
//    let persistenceController = PersistenceController.shared

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
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
