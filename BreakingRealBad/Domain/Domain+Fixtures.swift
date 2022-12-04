import Foundation

extension Character {
    static func fixture(
        id: Int = 32,
        name: String = "The tooth",
        portrayed: String = "Saul Goodman",
        imageUrl: URL? = URL(string: "https://hws.dev/paul.jpg"),
        isFavoured: Bool = false
    ) -> Self {
        self.init(
            id: id,
            name: name,
            portrayed: portrayed,
            imageUrl: imageUrl,
            isFavoured: isFavoured
        )
    }
}

extension CharacterQuote {
    static func fixture(
        id: Int = 32,
        line: String = "You did it",
        author: String = "Saul Goodman"
    ) -> Self {
        self.init(
            id: id,
            line: line,
            author: author
        )
    }
}
