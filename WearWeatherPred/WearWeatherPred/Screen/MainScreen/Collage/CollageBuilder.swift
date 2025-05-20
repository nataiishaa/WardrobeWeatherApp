import UIKit

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
            ctx.cgContext.setAllowsAntialiasing(true)
            ctx.cgContext.setShouldAntialias(true)
            ctx.cgContext.setAllowsFontSmoothing(true)
            ctx.cgContext.setShouldSmoothFonts(true)
            ctx.cgContext.setAllowsFontSubpixelPositioning(true)
            ctx.cgContext.setShouldSubpixelPositionFonts(true)
            
            UIColor.clear.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            
            let itemsByLayer = Dictionary(grouping: items) { $0.layer }
            
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
    
     func processImage(_ image: UIImage) -> UIImage? {
        guard let noBackgroundImage = backgroundRemover.removeBackground(from: image) else {
            return image
        }
        
        let targetSize = CGSize(width: 200, height: 200)
        let aspectRatio = image.size.width / image.size.height
        var newSize = targetSize
        
        if aspectRatio > 1 {
            newSize.height = targetSize.width / aspectRatio
        } else {
            newSize.width = targetSize.height * aspectRatio
        }
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { ctx in
            UIColor.clear.setFill()
            ctx.fill(CGRect(origin: .zero, size: newSize))
            
            noBackgroundImage.draw(in: CGRect(origin: .zero, size: newSize), blendMode: .normal, alpha: 1.0)
        }
        
        return resizedImage
    }
}
