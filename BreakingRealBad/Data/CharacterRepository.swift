import Combine
import CoreData

protocol CharacterRepositoryInterface {
    func fetchCharacters() -> AnyPublisher<[Character], Error>
    func fetchQuotes(ofCharacterName name: String) -> AnyPublisher<[CharacterQuote], Error>
    func save(character: Character) throws
    func savedCharacters() throws -> [CharacterFavourable]
}

final class CharacterRepository: CharacterRepositoryInterface {
    private let apiClient: APIClientRequestable
    private let viewContext: NSManagedObjectContext
    
    init(
        apiClient: APIClientRequestable = APIClient(),
        viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.apiClient = apiClient
        self.viewContext = viewContext
    }
    
    func savedCharacters() throws  -> [CharacterFavourable] {
        let request = Item.fetchRequest()
        let results = try viewContext.fetch(request)
        return results.map { FavouredCharacter(id: Int($0.id), isFavoured: $0.isFavoured) }
    }
    
    func save(character: Character) throws {
        let request = Item.fetchRequest()
        let items = try viewContext.fetch(request)
        let item = items.first(where: { $0.id == character.id }) ?? Item(context: viewContext)
        item.id = Int16(character.id)
        item.isFavoured = character.isFavoured
        try viewContext.save()
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
    
    struct FavouredCharacter: CharacterFavourable {
        let id: Int
        var isFavoured: Bool
    }
}
