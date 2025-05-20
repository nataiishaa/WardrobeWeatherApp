import Foundation

class GroqService {
    static let shared = GroqService()
    private let baseURL = "https://api.groq.com/openai/v1"
    private let apiKey: String
    private var style: OutfitType?
    
    private init() {
        guard let key = Secrets.shared.apiKey(for: "GROQ_API_KEY") else {
            fatalError("GROQ_API_KEY not found in Secrets.plist")
        }
        self.apiKey = key
    }
    
    func generateOutfitRecommendation(weather: WeatherData, style: OutfitType, availableItems: [ClothingItem]) async throws -> [ClothingItem] {
        self.style = style
        let prompt = """
        Based on the following weather conditions and available clothing items, suggest a complete outfit:
        
        Weather Conditions:
        - Temperature: \(weather.main.temp)°C
        - Weather: \(weather.weather.first?.main ?? "Clear")
        - Wind Speed: \(weather.wind.speed) m/s
        - Style: \(style.rawValue)
        
        Available Items:
        \(formatAvailableItems(availableItems))
        
        Please analyze the weather conditions and available items to suggest a complete outfit that includes:
        1. Top layer (if needed based on temperature and weather)
        2. Main top
        3. Bottom
        4. Shoes
        5. Accessories (if applicable)
        
        Consider:
        - Temperature appropriateness
        - Weather protection (rain, wind)
        - Style consistency
        - Practicality
        - Available items in the wardrobe
        
        Return the response in JSON format with the following structure:
        {
            "outfit": {
                "top": "item_id",
                "bottom": "item_id",
                "outer": "item_id",
                "shoes": "item_id",
                "accessory": "item_id"
            },
            "reasoning": "Brief explanation of the outfit choice"
        }
        """
        
        do {
            let response = try await generateWithGroq(prompt: prompt)
            return try parseOutfitResponse(response, availableItems: availableItems)
        } catch {
            print("[Groq] Failed to generate outfit: \(error)")
            return generateDefaultOutfit(weather: weather, availableItems: availableItems)
        }
    }
    
    private func formatAvailableItems(_ items: [ClothingItem]) -> String {
        var result = ""
        // Filter items by style and group by layer
        let filteredItems = items.filter { item in
            // Include items that match the style or have no style specified
            item.type == nil || item.type == style
        }
        let itemsByLayer = Dictionary(grouping: filteredItems, by: \.layer)
        
        for layer in Layer.allCases {
            if let layerItems = itemsByLayer[layer] {
                result += "\n\(layer):\n"
                for item in layerItems {
                    result += "- \(item.title) (ID: \(item.id), Season: \(item.season?.rawValue ?? "any"), Style: \(item.type?.rawValue ?? "any"), Waterproof: \(item.isWaterproof))\n"
                }
            }
        }
        return result
    }
    
    private func parseOutfitResponse(_ response: String, availableItems: [ClothingItem]) throws -> [ClothingItem] {
        guard let data = response.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let outfit = json["outfit"] as? [String: String] else {
            throw NSError(domain: "GroqService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }
        
        var selectedItems: [ClothingItem] = []
        
        let layerMapping: [String: Layer] = [
            "top": .top,
            "bottom": .bottom,
            "outer": .outer,
            "shoes": .shoes,
            "accessory": .accessory
        ]
        
        for (layerName, itemId) in outfit {
            guard let layer = layerMapping[layerName],
                  let uuid = UUID(uuidString: itemId),
                  let item = availableItems.first(where: { 
                      $0.id == uuid && 
                      $0.layer == layer && 
                      (style == nil || $0.type == nil || $0.type == style)
                  }) else {
                continue
            }
            selectedItems.append(item)
        }
        
        return selectedItems
    }
    
    private func generateDefaultOutfit(weather: WeatherData, availableItems: [ClothingItem]) -> [ClothingItem] {
        let itemsByLayer = Dictionary(grouping: availableItems, by: \.layer)
        var outfit: [ClothingItem] = []
        
        if let top = itemsByLayer[.top]?.first {
            outfit.append(top)
        }
        if let bottom = itemsByLayer[.bottom]?.first {
            outfit.append(bottom)
        }
        if let shoes = itemsByLayer[.shoes]?.first {
            outfit.append(shoes)
        }
        
        if weather.temperature < 12 || weather.isRaining || weather.isWindy {
            if let outer = itemsByLayer[.outer]?.first {
                outfit.append(outer)
            }
        }
        
        if let accessory = itemsByLayer[.accessory]?.first {
            outfit.append(accessory)
        }
        
        return outfit
    }
    
    private func generateWithGroq(prompt: String) async throws -> String {
        let requestBody: [String: Any] = [
            "model": "mixtral-8x7b-32768",
            "messages": [
                ["role": "system", "content": "You are a fashion expert specializing in weather-appropriate outfits."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 500
        ]
        
        guard let url = URL(string: "\(baseURL)/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        print("[Groq] Sending request to: \(url)")
        print("[Groq] Request body: \(String(data: request.httpBody!, encoding: .utf8) ?? "none")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("[Groq] Response status code: \(httpResponse.statusCode)")
        print("[Groq] Response body: \(String(data: data, encoding: .utf8) ?? "none")")
        
        if httpResponse.statusCode != 200 {
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = errorJson["error"] as? [String: Any],
               let message = error["message"] as? String {
                print("[Groq] API Error: \(message)")
            }
            throw URLError(.badServerResponse)
        }
        
        let groqResponse = try JSONDecoder().decode(GroqResponse.self, from: data)
        return groqResponse.choices.first?.message.content ?? "Failed to generate outfit description"
    }
}
