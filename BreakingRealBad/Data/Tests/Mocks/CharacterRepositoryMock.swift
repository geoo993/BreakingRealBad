import Combine
@testable import BreakingRealBad

final class CharacterRepositoryMock: CharacterRepositoryInterface {
    private (set)var favourites: [CharacterFavourable] = []
    private let characters: Result<[Character], Error>
    private let quotes: Result<[CharacterQuote], Error>
    
    init(
        favourites: [CharacterFavourable] = [],
        characters: Result<[Character], Error> = .success([]),
        quotes: Result<[CharacterQuote], Error> = .success([])
    ) {
        self.favourites = favourites
        self.characters = characters
        self.quotes = quotes
    }
 
    func fetchCharacters() -> AnyPublisher<[Character], Error> {
        characters.publisher.eraseToAnyPublisher()
    }
    
    func fetchQuotes(ofCharacterName name: String) -> AnyPublisher<[CharacterQuote], Error> {
        quotes.publisher.eraseToAnyPublisher()
    }
    
    func save(character: Character) throws {
        favourites.append(
            CharacterRepository.FavouredCharacter(
                id: character.id, isFavoured: character.isFavoured
            )
        )
    }

    func savedCharacters() throws -> [CharacterFavourable] {
        return favourites
    }
}


extension CharacterRepository.FavouredCharacter {
    static func fixtures(
        id: Int = 2,
        isFavoured: Bool = true
    ) -> CharacterRepository.FavouredCharacter {
        CharacterRepository.FavouredCharacter(
            id: id, isFavoured: isFavoured
        )
    }
}
