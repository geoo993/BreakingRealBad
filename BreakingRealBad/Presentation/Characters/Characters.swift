import ComposableArchitecture
import Foundation

enum Characters {
    struct State: Equatable {
        var characters: Loading<[Character]> = .idle
        var favouredCharactersId: [Int] = []
        var characterDetails: CharacterDetails.State = .init()
    }

    enum Action: Equatable {
        case fetchCharacters
        case didLoad(Result<[Character], AnyError>)
        case didSelect(Character)
        case characterDetails(CharacterDetails.Action)
    }
    
    struct Environment {
        let repository: CharacterRepositoryInterface
        let queue: AnySchedulerOf<DispatchQueue>
    }

    static let reducer: Reducer<State, Action, Environment> = .combine(
        CharacterDetails.reducer.pullback(
            state: \.characterDetails,
            action: /Action.characterDetails,
            environment: {
                .init(
                    repository: $0.repository,
                    queue: $0.queue
                )
            }
        ),
        .init { state, action, environment in
            switch action {
            case .fetchCharacters:
                state.characters = .loading()
                return environment.repository
                    .fetchCharacters()
                    .receive(on: environment.queue)
                    .mapError(AnyError.init)
                    .catchToEffect()
                    .map(Action.didLoad)
                
            case let .didLoad(result):
                state.characters = Loading.from(result: result)
                return .none
            case let .didSelect(character):
                // TODO: Refactor this logic and add persistence
                guard let characters = state.characters.loaded else { return .none }
                var newArr: [Int]
                if character.isFavoured {
                    newArr = state.favouredCharactersId
                    newArr.append(character.id)
                } else {
                    newArr = state.favouredCharactersId.filter{ $0 != character.id }
                }

                state.favouredCharactersId = newArr
                var newCharacters: [Character] = []
                characters.forEach { item in
                    var char = item
                    char.isFavoured = state.favouredCharactersId.contains(item.id)
                    newCharacters.append(char)
                }
                return Effect(value: .didLoad(.success(newCharacters)))
            case .characterDetails:
                return .none
            }
        }
    )
}
