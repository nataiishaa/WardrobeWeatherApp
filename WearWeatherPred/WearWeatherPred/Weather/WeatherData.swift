//
//  WeatherData.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let main: String
}

