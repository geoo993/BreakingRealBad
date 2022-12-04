import Foundation

protocol CharacterFavourable {
    var id: Int { get }
    var isFavoured: Bool { get set }
}

struct Character: Hashable, CharacterFavourable {
    let id: Int
    let name: String
    let portrayed: String
    let imageUrl: URL?
    var isFavoured: Bool
}
