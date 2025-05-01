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


//class WardrobeViewModel: ObservableObject {
//    static let shared = WardrobeViewModel()
//    
//    @Published var wardrobeItems: [ClothingItem] = [] 
//    
//    func addItem(_ item: ClothingItem) {
//        wardrobeItems.append(item)
//    }
//}
//


import SwiftUI
import UIKit

struct ClothingItemDTO: Codable {
    let id: UUID
    let title: String
    let category: String?
    let season: String?
    let type: String?
    let imageFilename: String
}

class WardrobeViewModel: ObservableObject {
    // MARK: - Singleton
    static let shared = WardrobeViewModel()
    private init() {
        load() // preload saved wardrobe on launch
    }

    // MARK: - Published items
    @Published var wardrobeItems: [ClothingItem] = [] {
        didSet { save() } // persist on every change
    }

    // MARK: - File locations
    private let jsonURL: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("wardrobe.json")
    }()

    // MARK: - Public API
    func addItem(_ item: ClothingItem) {
        wardrobeItems.append(item) // didSet triggers save()
    }

    func updateItem(_ item: ClothingItem) {
        guard let index = wardrobeItems.firstIndex(where: { $0.id == item.id }) else { return }
        wardrobeItems[index] = item // didSet saves
    }

    func deleteItem(_ item: ClothingItem) {
        wardrobeItems.removeAll { $0.id == item.id }
    }

    // MARK: - Persistence
    private func save() {
        // 1. Transform to DTOs & write images
        let dtos: [ClothingItemDTO] = wardrobeItems.compactMap { item in
            guard let jpegData = item.image.jpegData(compressionQuality: 0.8) else { return nil }
            let filename = "\(item.id).jpg"
            let fileURL = imageURL(for: filename)
            // write image only if not already there
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                try? jpegData.write(to: fileURL)
            }
            return ClothingItemDTO(id: item.id,
                                   title: item.title,
                                   category: item.category?.rawValue,
                                   season: item.season?.rawValue,
                                   type: item.type?.rawValue,
                                   imageFilename: filename)
        }

        do {
            let data = try JSONEncoder().encode(dtos)
            try data.write(to: jsonURL, options: .atomic)
        } catch {
            print("[Wardrobe] Failed to save: \(error)")
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: jsonURL.path) else { return }
        do {
            let data = try Data(contentsOf: jsonURL)
            let dtos = try JSONDecoder().decode([ClothingItemDTO].self, from: data)
            let items: [ClothingItem] = dtos.compactMap { dto in
                let fileURL = imageURL(for: dto.imageFilename)
                guard let img = UIImage(contentsOfFile: fileURL.path) else { return nil }
                return ClothingItem(image: img,
                                    title: dto.title,
                                    category: dto.category.flatMap { OutfitCategory(rawValue: $0) },
                                    season: dto.season.flatMap { OutfitSeason(rawValue: $0) },
                                    type: dto.type.flatMap { OutfitType(rawValue: $0) },
                                    id: dto.id)
            }
            self.wardrobeItems = items // will re‑save, but inexpensive
        } catch {
            print("[Wardrobe] Failed to load: \(error)")
        }
    }

    // MARK: - Helpers
    private func imageURL(for name: String) -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent(name)
    }
}

// MARK: - ClothingItem updated to accept id injection
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
