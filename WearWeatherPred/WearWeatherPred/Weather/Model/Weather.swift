public struct Weather: Codable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String
    
    public init(id: Int, main: String, description: String, icon: String) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}
