import Foundation
import SwiftUI

struct OutfitItem: Identifiable {
    let id = UUID()
    let name: String
    let category: ClothingCategory
    let image: UIImage
    let temperatureRange: ClosedRange<Double>
    let isWaterproof: Bool
    let isWindproof: Bool
}
