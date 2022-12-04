import XCTest
import Combine
@testable import BreakingRealBad

final class CharacterRepositoryTests: XCTestCase {
    var apiClient: APIClientMock!
    var repository: CharacterRepository!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        apiClient = APIClientMock()
        repository = CharacterRepository(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        repository = nil
        super.tearDown()
    }
    
    func testFetchCharacters() {
        apiClient.executePublisherCallback = {
            guard $0 is FetchCharactersRequest else {
                return .failure(.unknown)
            }
            return .success(FetchCharactersRequest.fixture())
        }
        XCTAssertFalse(apiClient.executePublisherCalled)
        let expectation = XCTestExpectation(description: #function)
        repository.fetchCharacters()
            .sinkToResult { result in
                switch result {
                case let .success(value):
                    XCTAssertEqual(value.count, 3)
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(apiClient.executePublisherCalled)
    }
    
    func testFetchQuotes() {
        apiClient.executePublisherCallback = {
            guard $0 is FetchCharacterQuotesRequest else {
                return .failure(.unknown)
            }
            return .success(FetchCharacterQuotesRequest.fixture())
        }
        XCTAssertFalse(apiClient.executePublisherCalled)
        let expectation = XCTestExpectation(description: #function)
        repository.fetchQuotes(ofCharacterName: "Sam")
            .sinkToResult { result in
                switch result {
                case let .success(value):
                    XCTAssertEqual(value.count, 7)
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(apiClient.executePublisherCalled)
    }
    
    // TODO: Add coredata persistence tests
}
