struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feels_like
        case temp_min
        case temp_max
        case humidity
    }
}
