import SwiftUI
import ComposableArchitecture

extension CharacterDetails {
    struct ContentView: View {
        @Binding var character: Character
        let store: Store<State, Action>
        
        var snsns: Bool {
            character.isFavoured
        }
        
        var body: some View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Unwrap(character.imageUrl) { value in
                        AvatarView(url: value, size: UIScreen.main.bounds.width * 0.9)
                    }
                    Unwrap(viewStore.quotes.loaded) { value in
                        List {
                            Section("characters_details__sectionTitle".localized) {
                                ForEach(value, id: \.id) { quote in
                                    Text(quote.line)
                                        .fontWeight(.light)
                                }
                            }
                        }
                    }
                }
                .navigationTitle(character.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            viewStore.send(.didLikeCharacter)
                            character.isFavoured = viewStore.isFavoured
                        }) {
                            Image(systemName: viewStore.isFavoured ? "heart.fill" : "heart")
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.fetchQuotes(character))
                }
            }
        }
    }
}
