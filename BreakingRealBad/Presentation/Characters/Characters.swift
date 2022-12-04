import ComposableArchitecture
import Foundation

enum Characters {
    struct State: Equatable {
        var characters: Loading<[Character]> = .idle
        var characterDetails: CharacterDetails.State = .init()
        var alertMessage: String?
    }

    enum Action: Equatable {
        case fetchCharacters
        case didLoad(Result<[Character], AnyError>)
        case didSelect(Character)
        case didSave
        case characterDetails(CharacterDetails.Action)
        case alertDismissed
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
                
            case let .didLoad(.success(values)):
                guard let favored = try? environment.repository.savedCharacters(), !favored.isEmpty else {
                    state.characters = .loaded(values)
                    return .none
                }
                var newCharacters: [Character] = []
                values.forEach { item in
                    var char = item
                    if let savedChar = favored.first(where: { $0.id == item.id }) {
                        char.isFavoured = savedChar.isFavoured
                    }
                    newCharacters.append(char)
                }
                state.characters = .loaded(newCharacters)
                return .none
            case let .didLoad(.failure(error)):
                state.characters = .error(error)
                state.alertMessage = (error.wrappedError as? CharacterRepository.Error)?.errorDescription ?? ""
                return .none
            case let .didSelect(character):
                guard let _ = try? environment.repository.save(character: character) else {
                    return .none
                }
                return Effect(value: Action.didSave)

            case .didSave:
                guard let characters = state.characters.loaded else { return .none }
                return Effect(value: .didLoad(.success(characters)))

            case .alertDismissed:
                state.alertMessage = nil
                return .none
            case .characterDetails:
                return .none
            }
        }
    )
}
