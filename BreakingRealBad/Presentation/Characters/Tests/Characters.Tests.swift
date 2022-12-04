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
            $0.characters = Loading.from(result: .failure(AnyError(error)))
        }
    }
}

extension CharactersTests {
    private func makeSut(
        characters: Result<[Character], Error> = .success([]),
        favouredCharactersId: Result<[Int], Error> = .success([])
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
                    charactersIds: favouredCharactersId,
                    characters: characters
                ),
                queue: testScheduler.eraseToAnyScheduler()
            )
        )
    }
} 
