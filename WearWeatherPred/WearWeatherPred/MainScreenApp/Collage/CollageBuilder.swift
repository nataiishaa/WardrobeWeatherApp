import UIKit

enum Layer { case top, bottom, shoes, accessory }

struct OutfitCollage {
    let image: UIImage
    let itemIDs: [UUID]
}

final class CollageBuilder {

    static func build(from ids:[UUID],
                      wardrobe:[UUID:ClothingItem],
                      size:CGSize = .init(width:160,height:200)) -> OutfitCollage? {

        let items = ids.compactMap { wardrobe[$0] }
        guard !items.isEmpty else { return nil }
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            UIColor.white.setFill(); ctx.fill(CGRect(origin:.zero,size:size))
            var y:CGFloat = 10
            for it in items {
                let h:CGFloat = 48
                it.image.draw(in:CGRect(x:10,y:y,width:size.width-20,height:h))
                y += h+6
            }
        }
        return .init(image: img, itemIDs: ids)
    }
}
