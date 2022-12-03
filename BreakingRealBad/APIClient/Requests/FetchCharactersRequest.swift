import Foundation

/// `GET /characters`
///
/// Fetches all characters from Breaking Bad
struct FetchCharactersRequest: HTTPRequest {    
    typealias ResponseObject = [APIClient.Character]
    typealias ErrorObject = APIError
    var path: String { "/characters" }
}
