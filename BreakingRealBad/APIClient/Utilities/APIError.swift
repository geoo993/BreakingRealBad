import Foundation

enum APIError: Swift.Error, Equatable {
    case unknown
    case dataTaskFailed(Swift.Error)
    case outdatedRequest
    case invalidUrlComponent
    case noResponse
    case error(HTTPCode)
    case decodingError(String)
    case limitReached

    var localizedDescription: String {
        switch self {
        case .unknown: return "Unknown"
        case .dataTaskFailed(let error): return "We encountered an issues during data task with error: \(error)"
        case .invalidUrlComponent: return "We encountered an error with url component"
        case .decodingError(let description): return "Failed to decode data: \(description)"
        case .outdatedRequest: return "The url you requested is outdated"
        case .noResponse: return "Did not get a HTTPURLResponse"
        case .error(let statusCode): return "We had a server error with status code \(statusCode)"
        case .limitReached: return "We reached the daily rate limit of 10,000 requests, try again tomorrow"
        }
    }
}

extension APIError {
    typealias HTTPCode = Int
    typealias HTTPCodes = Range<HTTPCode>
}

extension APIError.HTTPCodes {
    static let success = 200 ..< 300
    static let limitError = 429
    static let serverError = 501..<600
    static let outdated = 600...
}

extension APIError {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown),
            (.invalidUrlComponent, .invalidUrlComponent),
            (.outdatedRequest, .outdatedRequest),
            (.noResponse, .noResponse),
            (.limitReached, .limitReached):
            return true
        case let (.dataTaskFailed(left), .dataTaskFailed(right)):
            return left.localizedDescription == right.localizedDescription
        case (.decodingError(let left), .decodingError(let right)):
            return left == right
        case (.error(let left), .error(let right)):
            return left == right
        default:
            return false
        }
    }
}
