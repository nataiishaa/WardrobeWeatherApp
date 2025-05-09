import SwiftUI
import UIKit

struct ClothingItem: Identifiable {
    let id: UUID
    var image: UIImage
    var title: String
    var category: OutfitCategory?
    var season: OutfitSeason?
    var type: OutfitType?
    
    var layer: Layer {
        let key = title.lowercased()
        
        // First check category
        if let category = category {
            switch category {
            case .shoes: return .shoes
            case .accessories: return .accessory
            case .item: break // Continue to keyword check
            }
        }
        
        // Then check keywords
        if key.contains("jacket") || key.contains("coat") || key.contains("hoodie") || 
           key.contains("sweater") || key.contains("cardigan") || key.contains("blazer") {
            return .outer
        }
        if key.contains("pants") || key.contains("trousers") || key.contains("jeans") || 
           key.contains("skirt") || key.contains("shorts") || key.contains("leggings") {
            return .bottom
        }
        if key.contains("shirt") || key.contains("t-shirt") || key.contains("blouse") || 
           key.contains("top") || key.contains("sweater") || key.contains("dress") {
            return .top
        }
        
        // Default to top if no match found
        return .top
    }
}

enum OutfitCategory: String, CaseIterable {
    case accessories = "Accessories"
    case item = "Item"
    case shoes = "Shoes"
}

enum OutfitSeason: String, CaseIterable {
    case hot = "hot"
    case cold = "cold"
    case rainy = "rainy"
}

enum OutfitType: String, CaseIterable {
    case daily = "daily"
    case casual = "casual"
    case party = "party"
}

extension ClothingItem {
    init(image: UIImage,
         title: String,
         category: OutfitCategory? = nil,
         season: OutfitSeason? = nil,
         type: OutfitType? = nil,
         id: UUID = UUID()) {
        self.id = id
        self.image = image
        self.title = title
        self.category = category
        self.season = season
        self.type = type
    }
}
