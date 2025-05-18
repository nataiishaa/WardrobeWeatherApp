import SwiftUI

class OutfitGenerator {
    private var wardrobeItems: [OutfitItem] = []
    
    func addItem(_ item: OutfitItem) {
        wardrobeItems.append(item)
    }
    
    func generateOutfit(for weather: WeatherData) -> [OutfitItem] {
        var outfit: [OutfitItem] = []
        
        let suitableItems = wardrobeItems.filter { item in
            item.temperatureRange.contains(weather.temperature)
        }
        
        if let top = selectTop(from: suitableItems, weather: weather) {
            outfit.append(top)
        }
        
        if let bottom = selectBottom(from: suitableItems, weather: weather) {
            outfit.append(bottom)
        }
        
        if let outerwear = selectOuterwear(from: suitableItems, weather: weather) {
            outfit.append(outerwear)
        }
        
        if let accessory = selectAccessory(from: suitableItems, weather: weather) {
            outfit.append(accessory)
        }
        
        return outfit
    }
    
    private func selectTop(from items: [OutfitItem], weather: WeatherData) -> OutfitItem? {
        return items.filter { $0.category == .top }
            .sorted { abs($0.temperatureRange.lowerBound - weather.temperature) < abs($1.temperatureRange.lowerBound - weather.temperature) }
            .first
    }
    
    private func selectBottom(from items: [OutfitItem], weather: WeatherData) -> OutfitItem? {
        return items.filter { $0.category == .bottom }
            .sorted { abs($0.temperatureRange.lowerBound - weather.temperature) < abs($1.temperatureRange.lowerBound - weather.temperature) }
            .first
    }
    
    private func selectOuterwear(from items: [OutfitItem], weather: WeatherData) -> OutfitItem? {
        let outerwearItems = items.filter { $0.category == .outerwear }
        
        if weather.isRaining {
            return outerwearItems.filter { $0.isWaterproof }.first
        }
        
        if weather.isWindy {
            return outerwearItems.filter { $0.isWindproof }.first
        }
        
        return outerwearItems.first
    }
    
    private func selectAccessory(from items: [OutfitItem], weather: WeatherData) -> OutfitItem? {
        return items.filter { $0.category == .accessory }
            .sorted { abs($0.temperatureRange.lowerBound - weather.temperature) < abs($1.temperatureRange.lowerBound - weather.temperature) }
            .first
    }
}

extension OutfitGenerator {
    func createOutfitCollage(from outfit: [OutfitItem]) -> UIImage? {
        let canvasSize = CGSize(width: 800, height: 1000)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        for (index, item) in outfit.enumerated() {
            let itemSize = CGSize(width: 300, height: 400)
            let x = CGFloat(index % 2) * (itemSize.width + 50) + 50
            let y = CGFloat(index / 2) * (itemSize.height + 50) + 50
            
            let rect = CGRect(origin: CGPoint(x: x, y: y), size: itemSize)
            item.image.draw(in: rect)
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
} 
