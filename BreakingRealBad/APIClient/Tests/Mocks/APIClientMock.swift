import Combine
@testable import BreakingRealBad

final class APIClientMock: APIClientRequestable {
    var session: HTTPSession
    var executePublisherCalled = false
    var executePublisherCallback: ((_ request: Any) -> Result<Any,APIError>)?
    
    init(session: HTTPSession = HTTPSessionMock()) {
        self.session = session
    }
    
    func execute<T, V>(
        request: T
    ) -> AnyPublisher<V, T.ErrorObject>
    where T : HTTPRequest, V : Decodable, V == T.ResponseObject, T.ErrorObject == APIError {
        executePublisherCalled = true
        guard let callback = executePublisherCallback else {
            return Fail(
                outputType: T.ResponseObject.self,
                failure: APIError.unknown
            ).eraseToAnyPublisher()
        }
        let result = callback(request)
        switch result {
        case let .success(value as V):
            return Just(value)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        case let .failure(error):
            return Fail(
                outputType: T.ResponseObject.self,
                failure: error
            ).eraseToAnyPublisher()
        default:
            return Fail(
                outputType: T.ResponseObject.self,
                failure: APIError.unknown
            ).eraseToAnyPublisher()
        }
    }
}
