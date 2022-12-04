import Foundation

struct Character: Hashable {
    let id: Int
    let name: String
    let portrayed: String
    let imageUrl: URL?
    var isFavoured: Bool
}
