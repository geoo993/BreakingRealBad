import Foundation

/// `GET /quote?author={name}`
///
/// Fetches all quotes of a character from Breaking Bad
struct FetchCharacterQuotesRequest: HTTPRequest {
    typealias ResponseObject = [APIClient.CharacterQuote]
    typealias ErrorObject = APIError
    var path: String { "/quote" }
    var queryItems: [URLQueryItem]?
    
    init(characterName: String) {
        queryItems = [
            URLQueryItem(name: "author", value: characterName.replacingOccurrences(of: " ", with: "+"))
        ]
    }
}
