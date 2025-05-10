import SwiftUI
import UIKit

struct ClothingItem: Identifiable {
    let id: UUID
    var image: UIImage
    var title: String
    var category: OutfitCategory
    var season: OutfitSeason?
    var type: OutfitType?
    var density: OutfitDensity?
    var isWaterproof: Bool
    
    var layer: Layer {
        switch category {
        case .top: return .top
        case .bottom: return .bottom
        case .outer: return .outer
        case .shoes: return .shoes
        case .accessories: return .accessory
        }
    }
}

enum OutfitCategory: String, CaseIterable {
    case top = "Top"
    case bottom = "Bottom"
    case outer = "Outerwear"
    case shoes = "Shoes"
    case accessories = "Accessories"
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

enum OutfitDensity: String, CaseIterable {
    case light = "light"
    case medium = "medium"
    case heavy = "heavy"
}

extension ClothingItem {
    init(image: UIImage,
         title: String,
         category: OutfitCategory,
         season: OutfitSeason? = nil,
         type: OutfitType? = nil,
         density: OutfitDensity? = nil,
         isWaterproof: Bool = false,
         id: UUID = UUID()) {
        self.id = id
        self.image = image
        self.title = title
        self.category = category
        self.season = season
        self.type = type
        self.density = density
        self.isWaterproof = isWaterproof
    }
}
