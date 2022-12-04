import Combine
@testable import BreakingRealBad

final class CharacterRepositoryMock: CharacterRepositoryInterface {
    private let charactersIds: Result<[Int], Error>
    private let characters: Result<[Character], Error>
    private let quotes: Result<[CharacterQuote], Error>
    
    init(
        charactersIds: Result<[Int], Error> = .success([]),
        characters: Result<[Character], Error> = .success([]),
        quotes: Result<[CharacterQuote], Error> = .success([])
    ) {
        self.charactersIds = charactersIds
        self.characters = characters
        self.quotes = quotes
    }
    
    func favouredCharactersIds() -> AnyPublisher<[Int], Error> {
        charactersIds.publisher.eraseToAnyPublisher()
    }
    
    func fetchCharacters() -> AnyPublisher<[Character], Error> {
        characters.publisher.eraseToAnyPublisher()
    }
    
    func fetchQuotes(ofCharacterName name: String) -> AnyPublisher<[CharacterQuote], Error> {
        quotes.publisher.eraseToAnyPublisher()
    }
}
