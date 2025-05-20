import Foundation
import SwiftUI
struct WeatherView: View {
    
    @StateObject private var weatherService = WeatherService()
    var city: String
    
    private var weatherBackground: AnyView {
        switch weatherService.weather?.weather.first?.main {
        case Constants.weatherClear:
            return AnyView(Image(Constants.bgSunny)
                            .resizable()
                            .scaledToFill())
        case Constants.weatherClouds:
            return AnyView(Image(Constants.bgCloudy)
                            .resizable()
                            .scaledToFill())
        case Constants.weatherRain:
            return AnyView(Image(Constants.bgRainy)
                            .resizable()
                            .scaledToFill())
        case Constants.weatherSnow:
            return AnyView(Image(Constants.bgSnowy)
                            .resizable()
                            .scaledToFill())
        case Constants.weatherMist, Constants.weatherHaze, Constants.weatherFog:
            return AnyView(Image(Constants.bgFoggy)
                            .resizable()
                            .scaledToFill())
        case Constants.weatherThunderstorm:
            return AnyView(Image(Constants.bgStorm)
                            .resizable()
                            .scaledToFill())
        default:
            return AnyView(Color.blue)
        }
    }
    
    var body: some View {
        ZStack {
            weatherBackground
                .frame(height: Constants.backgroundHeight)
                .clipShape(RoundedRectangle(cornerRadius: Constants.backgroundCornerRadius))

            VStack(alignment: .leading) {
                Text("\(Int(weatherService.weather?.main.temp ?? 0))°")
                    .montserrat(size: Constants.tempFontSize).bold()
                    .foregroundColor(.white)
                Text(city)
                    .montserrat(size: Constants.cityFontSize).bold()
                    .foregroundColor(.white)
                Text(weatherService.weather?.weather.first?.description.capitalized ?? Constants.loadingText)
                    .montserrat(size: Constants.descriptionFontSize).bold()
                    .foregroundColor(.white.opacity(Constants.descriptionOpacity))
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: Constants.backgroundHeight)
        .onAppear {
            weatherService.fetchWeather(city: city)
        }
    }
    
    private enum Constants {
        static let weatherClear = "Clear"
        static let weatherClouds = "Clouds"
        static let weatherRain = "Rain"
        static let weatherSnow = "Snow"
        static let weatherMist = "Mist"
        static let weatherHaze = "Haze"
        static let weatherFog = "Fog"
        static let weatherThunderstorm = "Thunderstorm"
        
        static let bgSunny = "sunny_bg"
        static let bgCloudy = "cloudy_bg"
        static let bgRainy = "rainy_bg"
        static let bgSnowy = "snowy_bg"
        static let bgFoggy = "foggy_bg"
        static let bgStorm = "storm_bg"
        
        static let backgroundHeight: CGFloat = 120
        static let backgroundCornerRadius: CGFloat = 20
        
        static let tempFontSize: CGFloat = 32
        static let cityFontSize: CGFloat = 32
        static let descriptionFontSize: CGFloat = 16
        static let descriptionOpacity: Double = 0.8
        
        static let loadingText = "Loading..."
    }
}
