import Combine
import XCTest

@testable import BreakingRealBad

final class FetchCharacterQuotesRequestTests: XCTestCase {
    var apiClient: APIClient!
    var session: HTTPSessionMock!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        session = HTTPSessionMock()
        apiClient = APIClient(session: session)
    }

    override func tearDown() {
        session = nil
        apiClient = nil
        super.tearDown()
    }

    func testRequest() {
        session.register(
            stub: HTTPSessionMock.Stub(
                path: "/api/quote",
                method: .get,
                statusCode: 201,
                data: FetchCharacterQuotesRequest.dummy()
            )
        )
        let request = FetchCharacterQuotesRequest(characterName: "Alex The Greats")
        var output = [APIClient.CharacterQuote]()
        let expectation = XCTestExpectation(description: "Completion")
        apiClient
            .execute(request: request)
            .sinkToResult { result in
                switch result {
                case let .success(value):
                    output = value
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(output.count, 7)
    }
}
