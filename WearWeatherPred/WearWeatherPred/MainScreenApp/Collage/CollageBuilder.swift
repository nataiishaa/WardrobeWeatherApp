import UIKit

enum Layer: Int, CaseIterable {
    case bottom = 0
    case top = 1
    case outer = 2
    case shoes = 3
    case accessory = 4
    
    var size: CGSize {
        switch self {
        case .bottom: return CGSize(width: 200, height: 300)
        case .top: return CGSize(width: 180, height: 250)
        case .outer: return CGSize(width: 220, height: 320)
        case .shoes: return CGSize(width: 160, height: 120)
        case .accessory: return CGSize(width: 140, height: 140)
        }
    }
    
    var position: CGPoint {
        switch self {
        case .bottom: return CGPoint(x: 100, y: 200)
        case .top: return CGPoint(x: 120, y: 100)
        case .outer: return CGPoint(x: 90, y: 80)
        case .shoes: return CGPoint(x: 130, y: 500)
        case .accessory: return CGPoint(x: 20, y: 150)
        }
    }
}

struct OutfitCollage {
    let image: UIImage
    let itemIDs: [UUID]
}

final class CollageBuilder {
    static let shared = CollageBuilder()
    private let backgroundRemover = BackgroundRemover.shared
    
    private init() {}
    
    static func build(from ids: [UUID],
                     wardrobe: [UUID: ClothingItem],
                     size: CGSize = CGSize(width: 400, height: 600)) -> OutfitCollage? {
        return shared.buildCollage(from: ids, wardrobe: wardrobe, size: size)
    }
    
    private func buildCollage(from ids: [UUID],
                            wardrobe: [UUID: ClothingItem],
                            size: CGSize) -> OutfitCollage? {
        let items = ids.compactMap { wardrobe[$0] }
        guard !items.isEmpty else { return nil }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            // Draw white background
            UIColor.white.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            
            // Group items by layer
            let itemsByLayer = Dictionary(grouping: items) { $0.layer }
            
            // Draw items in order of layers
            for layer in Layer.allCases {
                if let layerItems = itemsByLayer[layer] {
                    for item in layerItems {
                        if let processedImage = processImage(item.image) {
                            let rect = CGRect(origin: layer.position,
                                           size: layer.size)
                            processedImage.draw(in: rect)
                        }
                    }
                }
            }
        }
        
        return OutfitCollage(image: img, itemIDs: ids)
    }
    
    private func processImage(_ image: UIImage) -> UIImage? {
        // Remove background
        guard let noBackgroundImage = backgroundRemover.removeBackground(from: image) else {
            return image
        }
        
        // Resize while maintaining aspect ratio
        let targetSize = CGSize(width: 200, height: 200)
        let aspectRatio = image.size.width / image.size.height
        var newSize = targetSize
        
        if aspectRatio > 1 {
            newSize.height = targetSize.width / aspectRatio
        } else {
            newSize.width = targetSize.height * aspectRatio
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { ctx in
            noBackgroundImage.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
