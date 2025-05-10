import UIKit

enum Layer: Int, CaseIterable {
    case top = 0
    case bottom = 1
    case outer = 2
    case shoes = 3
    case accessory = 4
    
    var size: CGSize {
        switch self {
        case .top: return CGSize(width: 250, height: 350)
        case .bottom: return CGSize(width: 280, height: 400)
        case .outer: return CGSize(width: 300, height: 450)
        case .shoes: return CGSize(width: 220, height: 160)
        case .accessory: return CGSize(width: 180, height: 180)
        }
    }
    
    var position: CGPoint {
        switch self {
        case .top: return CGPoint(x: 180, y: 150)
        case .bottom: return CGPoint(x: 160, y: 300)
        case .outer: return CGPoint(x: 150, y: 120)
        case .shoes: return CGPoint(x: 180, y: 650)
        case .accessory: return CGPoint(x: 50, y: 250)
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
            
            // Enable alpha channel
            ctx.cgContext.setAllowsAntialiasing(true)
            ctx.cgContext.setShouldAntialias(true)
            ctx.cgContext.setAllowsFontSmoothing(true)
            ctx.cgContext.setShouldSmoothFonts(true)
            ctx.cgContext.setAllowsFontSubpixelPositioning(true)
            ctx.cgContext.setShouldSubpixelPositionFonts(true)
            
            // Group items by layer
            let itemsByLayer = Dictionary(grouping: items) { $0.layer }
            
            // Draw items in order of layers
            for layer in Layer.allCases {
                if let layerItems = itemsByLayer[layer] {
                    for item in layerItems {
                        if let processedImage = processImage(item.image) {
                            let rect = CGRect(origin: layer.position,
                                           size: layer.size)
                            processedImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
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
        
        // Create a transparent background
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { ctx in
            // Clear the background
            UIColor.clear.setFill()
            ctx.fill(CGRect(origin: .zero, size: newSize))
            
            // Draw the image with transparency
            noBackgroundImage.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return resizedImage
    }
}
