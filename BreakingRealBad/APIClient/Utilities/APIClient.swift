import Foundation
import Combine

protocol APIClientRequestable {
    var session: HTTPSession { get }
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) -> AnyPublisher<V, T.ErrorObject>
    where T.ResponseObject == V, T.ErrorObject == APIError
}

final class APIClient {
    let session: HTTPSession

    init(session: HTTPSession = URLSession.shared) {
        self.session = session
    }
}

extension APIClient: APIClientRequestable {
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) -> AnyPublisher<V, T.ErrorObject>
    where T.ResponseObject == V, T.ErrorObject == APIError {
        guard let url = self.request(from: request) else {
            return Fail(error: APIError.invalidUrlComponent).eraseToAnyPublisher()
        }
        return session.dataTaskResponse(for: url)
            .receive(on: request.queue)
            .mapError { .dataTaskFailed($0) }
            .flatMap(process)
            .eraseToAnyPublisher()
    }

    private func request<T: HTTPRequest>(from endPoint: T) -> URLRequest? {
        guard let url = endPoint.baseUrl else { return nil }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.path = endPoint.path
        urlComponents?.queryItems = endPoint.queryItems
        guard let url = urlComponents?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.timeoutInterval = endPoint.timeoutInterval
        return request
    }
    
    private func process<T: Decodable>(
        _ result: URLSession.DataTaskPublisher.Output
    ) -> AnyPublisher<T, APIError> {
        let responseValue = result.response as? HTTPURLResponse
        switch (result.data, responseValue) {
        case let (data, .some(response)) where APIError.HTTPCodes.success ~= response.statusCode:
            return decode(data: data)
        case let (_, .some(response)):
            return Fail(error: error(for: response.statusCode)).eraseToAnyPublisher()
        default:
            return Fail(error: .noResponse).eraseToAnyPublisher()
        }
    }
    
    private func decode<T: Decodable>(
        data: Data
    ) -> AnyPublisher<T, APIError> {
        return Just(data)
            .decode(type: T.self, decoder:  JSONDecoder())
            .mapError { .decodingError($0.localizedDescription) }
            .eraseToAnyPublisher()
    }

    private func error(
        for code: APIError.HTTPCode
    ) -> APIError {
        switch code {
        case APIError.HTTPCodes.serverError: return .error(code)
        case APIError.HTTPCodes.limitError: return .limitReached
        case APIError.HTTPCodes.outdated: return .outdatedRequest
        default: return .unknown
        }
    }
}
