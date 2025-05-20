import SwiftUI

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
