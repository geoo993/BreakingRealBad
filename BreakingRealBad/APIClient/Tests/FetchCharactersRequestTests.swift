import Combine
import XCTest

@testable import BreakingRealBad

final class FetchCharactersRequestTests: XCTestCase {
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
                path: "/api/characters",
                method: .get,
                statusCode: 201,
                data: FetchCharactersRequest.dummy()
            )
        )
        let request = FetchCharactersRequest()
        var output = [APIClient.Character]()
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
        XCTAssertEqual(output.count, 3)
    }
}
