import Combine
import Foundation

protocol CharacterRepositoryInterface {
    func favouredCharactersIds() -> AnyPublisher<[Int], Error>
    func fetchCharacters() -> AnyPublisher<[Character], Error>
    func fetchQuotes(ofCharacterName name: String) -> AnyPublisher<[CharacterQuote], Error>
}

final class CharacterRepository: CharacterRepositoryInterface {
    let apiClient: APIClientRequestable
    
    init(apiClient: APIClientRequestable = APIClient()) {
        self.apiClient = apiClient
    }
    
    func favouredCharactersIds() -> AnyPublisher<[Int], Swift.Error> {
        Fail(error: APIError.unknown).eraseToAnyPublisher()
    }
    
    func fetchCharacters() -> AnyPublisher<[Character], Swift.Error> {
        apiClient
            .execute(request: FetchCharactersRequest())
            .map { $0.map(Character.init) }
            .mapError { Error.apiError($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchQuotes(ofCharacterName name: String) -> AnyPublisher<[CharacterQuote], Swift.Error> {
        apiClient
            .execute(request: FetchCharacterQuotesRequest(characterName: name))
            .map { $0.map(CharacterQuote.init) }
            .mapError { Error.apiError($0) }
            .eraseToAnyPublisher()
    }
}

extension CharacterRepository {
    enum Error: LocalizedError, Equatable {
        case apiError(APIError)
        
        var errorDescription: String? {
            switch self {
            case let .apiError(error):
                return "error_alert_description".localized(arguments: error.localizedDescription)
            }
        }
    }
}
