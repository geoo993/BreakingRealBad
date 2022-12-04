extension Character {
    init(model: APIClient.Character) {
        self.init(
            id: model.id,
            name: model.name,
            portrayed: model.portrayed,
            imageUrl: model.imageUrl,
            isFavoured: false
        )
    }
}

extension CharacterQuote {
    init(model: APIClient.CharacterQuote) {
        self.init(
            id: model.id,
            line: model.line,
            author: model.author
        )
    }
}
