import Foundation
import SwiftUI

struct WeatherView: View {
    
    @StateObject private var weatherService = WeatherService()
    var city: String
    
    var weatherBackground: AnyView {
        switch weatherService.weather?.weather.first?.main {
        case "Clear":
            return AnyView(Image("sunny_bg")
                            .resizable()
                            .scaledToFill())
        case "Clouds":
            return AnyView(Image("cloudy_bg")
                            .resizable()
                            .scaledToFill())
        case "Rain":
            return AnyView(Image("rainy_bg")
                            .resizable()
                            .scaledToFill())
        case "Snow":
            return AnyView(Image("snowy_bg")
                            .resizable()
                            .scaledToFill())
        case "Mist", "Haze", "Fog":
            return AnyView(Image("foggy_bg")
                            .resizable()
                            .scaledToFill())
        case "Thunderstorm":
            return AnyView(Image("storm_bg")
                            .resizable()
                            .scaledToFill())
        default:
            return AnyView(Color.blue)
        }
    }
    
    var body: some View {
            ZStack {
                weatherBackground
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading) {
                    Text("\(Int(weatherService.weather?.main.temp ?? 0))°")
                        .montserrat(size: 32).bold()
                        .foregroundColor(.white)
                    Text(city)
                        .montserrat(size: 32).bold()
                        .foregroundColor(.white)
                    Text(weatherService.weather?.weather.first?.description.capitalized ?? "Loading...")
                        .montserrat(size: 16).bold()
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .onAppear {
                weatherService.fetchWeather(city: city)
            }
        }
}
