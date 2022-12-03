import Foundation

extension APIClient {
    struct Character: Decodable {
        let id: Int
        let name: String
        let portrayed: String
        let imageUrl: URL?
    }
}

extension APIClient.Character {
    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case portrayed
        case imageUrl = "img"
    }
}
