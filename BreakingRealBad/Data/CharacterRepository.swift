import Combine

protocol CharacterRepositoryInterface {
    func fetchFavouredCharacters() -> AnyPublisher<[Character], Error>
    func fetchCharacters() -> AnyPublisher<[Character], Error>
    func fetchQuotes(ofCharacterId id: Int) -> AnyPublisher<[CharacterQuote], Error>
}

final class CharacterRepository: CharacterRepositoryInterface {
    
    enum Error: Swift.Error {
        case noData
    }
    
    func fetchFavouredCharacters() -> AnyPublisher<[Character], Swift.Error> {
        Fail(error: Error.noData).eraseToAnyPublisher()
    }
    
    func fetchCharacters() -> AnyPublisher<[Character], Swift.Error> {
        Fail(error: Error.noData).eraseToAnyPublisher()
    }
    
    func fetchQuotes(ofCharacterId id: Int) -> AnyPublisher<[CharacterQuote], Swift.Error> {
        Fail(error: Error.noData).eraseToAnyPublisher()
    }
}
