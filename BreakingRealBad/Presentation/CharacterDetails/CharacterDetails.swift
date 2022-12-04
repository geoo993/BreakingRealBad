import ComposableArchitecture
import Foundation

enum CharacterDetails {
    struct State: Equatable {
        var selectedCharacter: Character?
        var isFavoured: Bool { return selectedCharacter?.isFavoured ?? false }
        var quotes: Loading<[CharacterQuote]> = .idle
    }

    enum Action: Equatable {
        case fetchQuotes(Character)
        case didLoad(Result<[CharacterQuote], AnyError>)
        case didLikeCharacter
    }
    
    struct Environment {
        let repository: CharacterRepositoryInterface
        let queue: AnySchedulerOf<DispatchQueue>
    }

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
      switch action {
      case let .fetchQuotes(character):
          state.selectedCharacter = character
          state.quotes = .loading()
          return environment.repository
              .fetchQuotes(ofCharacterName: character.name)
              .receive(on: environment.queue)
              .mapError(AnyError.init)
              .catchToEffect()
              .map(Action.didLoad)
          
      case let .didLoad(result):
          state.quotes = Loading.from(result: result)
          return .none
      case .didLikeCharacter:
          state.selectedCharacter?.isFavoured.toggle()
          return .none
      }
    }
}
