import SwiftUI
import UIKit

struct ClothingItem: Identifiable {
    let id: UUID
    var image: UIImage
    var title: String
    var category: OutfitCategory?
    var season: OutfitSeason?
    var type: OutfitType?
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
