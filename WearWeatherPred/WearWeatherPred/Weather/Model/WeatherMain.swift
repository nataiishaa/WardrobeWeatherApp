public struct Main: Codable {
    public let temp: Double
    public let feels_like: Double
    public let temp_min: Double
    public let temp_max: Double
    public let humidity: Int
    
    public init(temp: Double, feels_like: Double, temp_min: Double, temp_max: Double, humidity: Int) {
        self.temp = temp
        self.feels_like = feels_like
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.humidity = humidity
    }
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feels_like
        case temp_min
        case temp_max
        case humidity
    }
}
