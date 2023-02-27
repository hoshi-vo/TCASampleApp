struct GitHubItemsEntity: Decodable, Equatable {
    var items: [GitHubItemEntity]

    init(items: [GitHubItemEntity]) {
        self.items = items
    }
}
