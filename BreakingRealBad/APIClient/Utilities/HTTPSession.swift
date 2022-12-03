import Foundation
import Combine

protocol HTTPSession {
    typealias HTTPResponse = URLSession.DataTaskPublisher.Output
    func dataTaskResponse(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError>
}

extension URLSession: HTTPSession {
    func dataTaskResponse(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
