import Foundation

class WeatherService: ObservableObject {
    @Published var weather: WeatherData?
    
    func fetchWeather(city: String) {
        guard let apiKey = Secrets.shared.apiKey(for: "OPENWEATHER_API_KEY") else {
            print("API key not found")
            return
        }
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weather = result
                }
            } catch {
                print("Ошибка декодирования JSON: \(error)")
            }
        }.resume()
    }
}
