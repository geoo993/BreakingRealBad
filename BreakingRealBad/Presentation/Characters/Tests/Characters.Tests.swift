import XCTest
import ComposableArchitecture
@testable import BreakingRealBad

@MainActor
final class CharactersTests: XCTestCase {
    private let testScheduler = DispatchQueue.test

    func testFetchingCharactersSucceed() async {
        let store = makeSut(
            characters: .success([.fixture()])
        )
        await store.send(.fetchCharacters) {
            $0.characters = .loading(previous: .none)
        }
        await testScheduler.advance(by: 1)
        await store.receive(.didLoad(.success([.fixture()]))) {
            $0.characters = .loaded([.fixture()])
        }
    }
    
    func testFetchingCharactersFails() async {
        let error = APIError.unknown
        let store = makeSut(
            characters: .failure(error)
        )
        await store.send(.fetchCharacters) {
            $0.characters = .loading(previous: .none)
        }
        await testScheduler.advance(by: 1)
        await store.receive(.didLoad(.failure(AnyError(error)))) {
            $0.characters = .error(AnyError(error))
        }
    }
    
    func testDidFavourCharacter() async {
        let characters: [Character] = [
            .fixture(id: 3, isFavoured: false),
            .fixture(id: 4, isFavoured: false)
        ]
        let store = makeSut(characters: .success(characters))
        await store.send(.fetchCharacters) {
            $0.characters = .loading(previous: .none)
        }
        await testScheduler.advance(by: 1)
        await store.receive(.didLoad(.success(characters))) {
            $0.characters = .loaded(characters)
        }
        await store.send(.didSelect(.fixture(id: 3, isFavoured: true)))
        await store.receive(.didSave)
        let newCharacters: [Character] = [
            .fixture(id: 3, isFavoured: true),
            .fixture(id: 4, isFavoured: false)
        ]
        await store.receive(.didLoad(.success(characters))) {
            $0.characters = .loaded(newCharacters)
        }
    }
    
    func testDidUnfavourCharacter() async {
        let characters: [Character] = [
            .fixture(id: 3, isFavoured: true),
            .fixture(id: 4, isFavoured: false)
        ]
        let store = makeSut(characters: .success(characters))
        await store.send(.fetchCharacters) {
            $0.characters = .loading(previous: .none)
        }
        await testScheduler.advance(by: 1)
        await store.receive(.didLoad(.success(characters))) {
            $0.characters = .loaded(characters)
        }
        await store.send(.didSelect(.fixture(id: 3, isFavoured: false)))
        await store.receive(.didSave)
        let newCharacters: [Character] = [
            .fixture(id: 3, isFavoured: false),
            .fixture(id: 4, isFavoured: false)
        ]
        await store.receive(.didLoad(.success(characters))) {
            $0.characters = .loaded(newCharacters)
        }
    }
}

extension CharactersTests {
    private func makeSut(
        characters: Result<[Character], Error> = .success([]),
        favouredCharacters: [CharacterFavourable] = []
    ) -> TestStore<
        Characters.State,
        Characters.State,
        Characters.Action,
        Characters.Action,
        Characters.Environment
    > {
        .init(
            initialState: .init(),
            reducer: Characters.reducer,
            environment: .init(
                repository: CharacterRepositoryMock(
                    favourites: favouredCharacters,
                    characters: characters
                ),
                queue: testScheduler.eraseToAnyScheduler()
            )
        )
    }
} 
