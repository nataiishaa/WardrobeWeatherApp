import SwiftUI

//struct ClothingItem: Identifiable {
//    let id = UUID()
//    var image: UIImage
//    var title: String
//    var category: OutfitCategory
//    var season: String
//    var type: String
//
//    static let placeholder = ClothingItem(image: UIImage(), title: "New Item", category: .casual, season: "Hot", type: "Daily")
//}
//
//enum OutfitCategory: String, CaseIterable {
//    case casual = "Casual"
//    case daily = "Daily"
//    case party = "Party"
//}


import SwiftUI
import UIKit

import SwiftUI

struct ClothingItem: Identifiable {
    let id = UUID()
    var image: UIImage
    var title: String
    var category: OutfitCategory
    var season: String
    var type: String
}

enum OutfitCategory: String, CaseIterable {
    case accessories = "Accessories"
    case item = "Item"
    case shoes = "Shoes"
}

class WardrobeViewModel: ObservableObject {
    static let shared = WardrobeViewModel()
    
    @Published var wardrobeItems: [ClothingItem] = [] 
    
    func addItem(_ item: ClothingItem) {
        wardrobeItems.append(item)
    }
}

