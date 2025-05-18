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
