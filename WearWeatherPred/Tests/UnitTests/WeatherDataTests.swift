import XCTest
@testable import WearWeatherPred

final class WeatherDataTests: XCTestCase {
    
    func testWeatherDataDecoding() {
        let jsonString = """
        {
            "main": {
                "temp": 20.5,
                "feels_like": 19.8,
                "temp_min": 18.0,
                "temp_max": 22.0,
                "pressure": 1015,
                "humidity": 65
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "name": "Moscow",
            "wind": {
                "speed": 6.0,
                "deg": 180
            }
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let weatherData = try? JSONDecoder().decode(WeatherData.self, from: jsonData)
        
        XCTAssertNotNil(weatherData)
        XCTAssertEqual(weatherData?.name, "Moscow")
        XCTAssertEqual(weatherData?.temperature, 20.5)
        XCTAssertTrue(weatherData?.isRaining ?? false)
        XCTAssertTrue(weatherData?.isWindy ?? false)
    }
    
    func testWeatherDataProperties() {
        let main = Main(temp: 25.0, feels_like: 24.0, temp_min: 22.0, temp_max: 27.0, humidity: 60)
        let weather = [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")]
        let wind = Wind(speed: 3.0, deg: 90)
        
        let weatherData = WeatherData(main: main, weather: weather, name: "London", wind: wind)
        
        XCTAssertEqual(weatherData.temperature, 25.0)
        XCTAssertFalse(weatherData.isRaining)
        XCTAssertFalse(weatherData.isWindy)
    }
    
    func testWeatherDataWithRain() {
        let main = Main(temp: 18.0, feels_like: 17.0, temp_min: 16.0, temp_max: 20.0, humidity: 85)
        let weather = [Weather(id: 500, main: "Rain", description: "moderate rain", icon: "10d")]
        let wind = Wind(speed: 4.0, deg: 270)
        
        let weatherData = WeatherData(main: main, weather: weather, name: "Paris", wind: wind)
        
        XCTAssertTrue(weatherData.isRaining)
        XCTAssertFalse(weatherData.isWindy)
    }
    
    func testWeatherDataWithWind() {
        let main = Main(temp: 15.0, feels_like: 14.0, temp_min: 13.0, temp_max: 17.0, humidity: 70)
        let weather = [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")]
        let wind = Wind(speed: 7.0, deg: 180)
        
        let weatherData = WeatherData(main: main, weather: weather, name: "Berlin", wind: wind)
        
        XCTAssertFalse(weatherData.isRaining)
        XCTAssertTrue(weatherData.isWindy)
    }
} 
