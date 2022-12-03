import Foundation
import Combine

@testable import  BreakingRealBad

final class HTTPSessionMock: HTTPSession {
    private var stub: Stub?
    
    func register(stub: Stub) {
        self.stub = stub
    }
    
    func dataTaskResponse(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError> {
        let stub = self.registeredStub(for: request)
        guard
            let statusCode = stub?.statusCode,
            let url = request.url,
            let data = stub?.data
        else {
            return Fail(error: URLError(.dataNotAllowed)).eraseToAnyPublisher()
        }
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: nil
        )!
        return Just((data, response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
    
    private func registeredStub(for request: URLRequest) -> Stub? {
        guard
            let stub,
            let path = request.url?.path,
            request.httpMethod == stub.method.rawValue,
            path == stub.path
        else { return nil }
        return stub
    }
}

extension HTTPSessionMock {
    struct Stub {
        let path: String
        let method: HTTPMethod
        let statusCode: APIError.HTTPCode
        let data: Data

        init(
            path: String,
            method: HTTPMethod,
            statusCode: APIError.HTTPCode,
            data: Data = Data()
        ) {
            self.path = path
            self.method = method
            self.statusCode = statusCode
            self.data = data
        }
    }
}
