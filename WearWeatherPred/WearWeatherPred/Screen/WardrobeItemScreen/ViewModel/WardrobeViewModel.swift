import SwiftUI
import UIKit

struct ClothingItemDTO: Codable {
    let id: UUID
    let title: String
    let category: String
    let season: String?
    let type: String?
    let density: String?
    let isWaterproof: Bool
    let imageFilename: String
}

class WardrobeViewModel: ObservableObject {
    // MARK: - Singleton
    static let shared = WardrobeViewModel()
    private init() {
        load()
    }

    // MARK: - Published items
    @Published var wardrobeItems: [ClothingItem] = [] {
        didSet { save() }
    }

    // MARK: - File locations
    private let jsonURL: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("wardrobe.json")
    }()

    // MARK: - Public API
    func addItem(_ item: ClothingItem) {
        wardrobeItems.append(item)
    }

    func updateItem(_ item: ClothingItem) {
        guard let index = wardrobeItems.firstIndex(where: { $0.id == item.id }) else { return }
        wardrobeItems[index] = item
    }

    func deleteItem(_ item: ClothingItem) {
        wardrobeItems.removeAll { $0.id == item.id }
    }

    // MARK: - Persistence
    private func save() {
        let dtos: [ClothingItemDTO] = wardrobeItems.compactMap { item in
            guard let jpegData = item.image.jpegData(compressionQuality: 0.8) else { return nil }
            let filename = "\(item.id).jpg"
            let fileURL = imageURL(for: filename)
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                try? jpegData.write(to: fileURL)
            }
            return ClothingItemDTO(id: item.id,
                                   title: item.title,
                                   category: item.category.rawValue,
                                   season: item.season?.rawValue,
                                   type: item.type?.rawValue,
                                   density: item.density?.rawValue,
                                   isWaterproof: item.isWaterproof,
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
                guard let category = OutfitCategory(rawValue: dto.category) else { return nil }
                return ClothingItem(image: img,
                                    title: dto.title,
                                    category: category,
                                    season: dto.season.flatMap { OutfitSeason(rawValue: $0) },
                                    type: dto.type.flatMap { OutfitType(rawValue: $0) },
                                    density: dto.density.flatMap { OutfitDensity(rawValue: $0) },
                                    isWaterproof: dto.isWaterproof,
                                    id: dto.id)
            }
            self.wardrobeItems = items
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
