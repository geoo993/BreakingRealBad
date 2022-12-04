import SwiftUI
import ComposableArchitecture

extension Characters {
    struct ContentView: View {
        let store: Store<State, Action>
        let color = Color(UIColor.systemBackground)
        
        var body: some View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                NavigationStack {
                    Unwrap(viewStore.characters.loaded) { value in
                        List(value, id: \.id) { character in
                            ZStack {
                                NavigationLink(value: character) {
                                    EmptyView()
                                }
                                CardView(character:
                                    Binding(get: {
                                        character
                                    }, set: {
                                        viewStore.send(.didSelect($0))
                                    })
                                )
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(color)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listStyle(GroupedListStyle())
                        .navigationTitle("characters_list__screen")
                        .navigationDestination(for: Character.self) { character in
                            CharacterDetails.ContentView(
                                character:
                                    Binding(get: {
                                        character
                                    }, set: {
                                        viewStore.send(.didSelect($0))
                                    }),
                                store: store.scope(
                                    state: \.characterDetails,
                                    action: Action.characterDetails
                                )
                            )
                        }
                        .toolbarBackground(color, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                    }
                }
                .onAppear {
                    viewStore.send(.fetchCharacters)
                }
                .alert(
                    Text(TextState("error_alert_title".localized)),
                    isPresented: Binding(
                        get: {
                            viewStore.alertMessage != nil
                        }, set: { _,_ in }
                    ),
                    presenting: viewStore.alertMessage
                ) { _ in
                    Button("error_alert_cta".localized) {
                        viewStore.send(.alertDismissed)
                    }
                } message: { message in
                    Unwrap(message) { value in
                        Text(value)
                    }
                }
            }
        }
    }
}
