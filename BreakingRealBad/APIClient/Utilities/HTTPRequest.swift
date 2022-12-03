import Foundation

protocol HTTPRequest {
    var baseUrl: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var timeoutInterval: TimeInterval { get }
    var queue: DispatchQueue { get }
    associatedtype ResponseObject: Any
    associatedtype ErrorObject: Error
}

enum HTTPMethod: String {
    case get = "GET"
}

extension HTTPRequest {
    var baseUrl: URL? { URL(string: "https://www.breakingbadapi.com/api") }
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? { nil }
    var timeoutInterval: TimeInterval { 30.0 }
    var queue: DispatchQueue { .main }
}
