import ComposableArchitecture
import XCTest
@testable import BreakingRealBad

@MainActor
final class CharacterDetailsTests: XCTestCase {
    private let testScheduler = DispatchQueue.test

    func testFetchingQuotesSucceed() async {
        let character: Character = .fixture()
        let store = makeSut(
            quotes: .success([.fixture()])
        )
        await store.send(.fetchQuotes(character)) {
            $0.selectedCharacter = character
            $0.quotes = .loading(previous: .none)
        }
        await testScheduler.advance(by: 1)
        await store.receive(.didLoad(.success([.fixture()]))) {
            $0.quotes = .loaded([.fixture()])
        }
    }
    
    func testFetchingQuotesFails() async {
        let character: Character = .fixture()
        let error = APIError.unknown
        let store = makeSut(
            quotes: .failure(error)
        )
        await store.send(.fetchQuotes(character)) {
            $0.selectedCharacter = character
            $0.quotes = .loading(previous: .none)
        }
        await testScheduler.advance(by: 1)
        await store.receive(.didLoad(.failure(AnyError(error)))) {
            $0.quotes = Loading.from(result: .failure(AnyError(error)))
        }
    }
    
    func testDidLikeCharacter() async {
        let character: Character = .fixture()
        let store = makeSut(
            selectedCharacter: character
        )
        await store.send(.didLikeCharacter) {
            $0.selectedCharacter?.isFavoured = true
        }
    }
}

extension CharacterDetailsTests {
    private func makeSut(
        selectedCharacter: Character? = nil,
        quotes: Result<[CharacterQuote], Error> = .success([])
    ) -> TestStore<
        CharacterDetails.State,
        CharacterDetails.State,
        CharacterDetails.Action,
        CharacterDetails.Action,
        CharacterDetails.Environment
    > {
        .init(
            initialState: .init(selectedCharacter: selectedCharacter),
            reducer: CharacterDetails.reducer,
            environment: .init(
                repository: CharacterRepositoryMock(
                    quotes: quotes
                ),
                queue: testScheduler.eraseToAnyScheduler()
            )
        )
    }
}
