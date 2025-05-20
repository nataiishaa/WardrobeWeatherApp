import XCTest
@testable import WearWeatherPred

final class WeatherDataEdgeCasesTests: XCTestCase {
    
    func testWeatherDataWithEmptyWeatherArray() {
        let main = Main(temp: 20.0, feels_like: 19.0, temp_min: 18.0, temp_max: 22.0, humidity: 60)
        let weather: [Weather] = []
        let wind = Wind(speed: 3.0, deg: 90)
        
        let weatherData = WeatherData(main: main, weather: weather, name: "London", wind: wind)
        
        XCTAssertFalse(weatherData.isRaining, "Empty weather array should not indicate rain")
    }
    
    func testWeatherDataWithMultipleWeatherConditions() {
        let main = Main(temp: 20.0, feels_like: 19.0, temp_min: 18.0, temp_max: 22.0, humidity: 60)
        let weather = [
            Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d"),
            Weather(id: 500, main: "Rain", description: "light rain", icon: "10d")
        ]
        let wind = Wind(speed: 3.0, deg: 90)
        
        let weatherData = WeatherData(main: main, weather: weather, name: "London", wind: wind)
        
        XCTAssertTrue(weatherData.isRaining, "Should detect rain in multiple weather conditions")
    }
    
    func testWeatherDataWithWindyThreshold() {
        let main = Main(temp: 20.0, feels_like: 19.0, temp_min: 18.0, temp_max: 22.0, humidity: 60)
        let weather = [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")]
        let wind = Wind(speed: 5.0, deg: 90)
        
        let weatherData = WeatherData(main: main, weather: weather, name: "London", wind: wind)
        
        XCTAssertFalse(weatherData.isWindy, "Wind speed exactly at threshold should not be considered windy")
    }
    
    func testWeatherDataWithExtremeTemperatures() {
        let main = Main(temp: -40.0, feels_like: -45.0, temp_min: -45.0, temp_max: -35.0, humidity: 60)
        let weather = [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")]
        let wind = Wind(speed: 3.0, deg: 90)
        
        let weatherData = WeatherData(main: main, weather: weather, name: "Yakutsk", wind: wind)
        
        XCTAssertEqual(weatherData.temperature, -40.0, "Should handle negative temperatures correctly")
    }
    
    func testWeatherDataWithSpecialCharactersInName() {
        let main = Main(temp: 20.0, feels_like: 19.0, temp_min: 18.0, temp_max: 22.0, humidity: 60)
        let weather = [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")]
        let wind = Wind(speed: 3.0, deg: 90)
        let cityName = "São Paulo"
        
        let weatherData = WeatherData(main: main, weather: weather, name: cityName, wind: wind)
        
        XCTAssertEqual(weatherData.name, cityName, "Should handle special characters in city name")
    }
} 
