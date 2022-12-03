import Foundation

extension APIClient {
    struct CharacterQuote: Decodable {
        let id: Int
        let line: String
        let author: String
    }
}

extension APIClient.CharacterQuote {
    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case line = "quote"
        case author
    }
}
