import SwiftUI

struct OutfitCardView: View {
    let collage: OutfitCollage
    @ObservedObject private var wardrobeVM = WardrobeViewModel.shared
    @State private var isSharePresented = false
    @State private var shareImage: UIImage?
    
    private enum Constants {
        static let cardWidth: CGFloat = 280
        static let cardHeight: CGFloat = 600
        static let horizontalSpacing: CGFloat = 20
        static let verticalSpacing: CGFloat = 30
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 10
        static let shadowYOffset: CGFloat = 5
        static let shadowOpacity: CGFloat = 0.1
        static let strokeLineWidth: CGFloat = 1
        static let shareButtonPadding: CGFloat = 8
        static let accessoryRectXMultiplier: CGFloat = 0.6
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let width = min(geometry.size.width, Constants.cardWidth)
                let height = width * 1.5

                VStack(spacing: 0) {
                    if let outer = itemForLayer(.outer) {
                        ProcessedImageView(image: outer.image)
                            .frame(height: height / 4)
                    }
                    if let top = itemForLayer(.top) {
                        ProcessedImageView(image: top.image)
                            .frame(height: height / 4)
                    }
                    if let bottom = itemForLayer(.bottom) {
                        ProcessedImageView(image: bottom.image)
                            .frame(height: height / 4)
                    }
                    HStack {
                        if let shoes = itemForLayer(.shoes) {
                            ProcessedImageView(image: shoes.image)
                                .frame(width: width / 2, height: height / 6)
                        }
                        if let accessory = itemForLayer(.accessory) {
                            ProcessedImageView(image: accessory.image)
                                .frame(width: width / 4, height: height / 8)
                        }
                    }
                }
                .frame(width: width, height: height)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius * (width / Constants.cardWidth)))
            }
            .aspectRatio(2/3, contentMode: .fit)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Perfect Match")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(collage.itemIDs.count) items")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    shareImage = renderOutfitImage()
                    isSharePresented = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.brandPrimary)
                        .padding(Constants.shareButtonPadding)
                        .background(Color.brandPrimary.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: 300)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .shadow(color: Color.black.opacity(Constants.shadowOpacity),
                radius: Constants.shadowRadius,
                x: 0,
                y: Constants.shadowYOffset)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Color.brandPrimary.opacity(0.1), lineWidth: Constants.strokeLineWidth)
        )
        .sheet(isPresented: $isSharePresented) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
    }
    
    private func itemForLayer(_ layer: Layer) -> ClothingItem? {
        collage.itemIDs.compactMap { id in
            wardrobeVM.wardrobeItems.first(where: { $0.id == id && $0.layer == layer })
        }.first
    }
    
    private func renderOutfitImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: Constants.cardWidth, height: Constants.cardHeight))
        return renderer.image { context in

            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: CGSize(width: Constants.cardWidth, height: Constants.cardHeight)))

            if let outer = itemForLayer(.outer) {
                if let processed = CollageBuilder.shared.processImage(outer.image) {
                    let rect = CGRect(x: 0, y: 0, width: Constants.cardWidth, height: Constants.cardHeight / 4)
                    processed.draw(in: rect)
                }
            }
            if let top = itemForLayer(.top) {
                if let processed = CollageBuilder.shared.processImage(top.image) {
                    let rect = CGRect(x: 0, y: Constants.cardHeight / 4, width: Constants.cardWidth, height: Constants.cardHeight / 4)
                    processed.draw(in: rect)
                }
            }
            if let bottom = itemForLayer(.bottom) {
                if let processed = CollageBuilder.shared.processImage(bottom.image) {
                    let rect = CGRect(x: 0, y: Constants.cardHeight / 2, width: Constants.cardWidth, height: Constants.cardHeight / 4)
                    processed.draw(in: rect)
                }
            }

            let shoesRect = CGRect(x: 0,
                                   y: Constants.cardHeight * 3 / 4,
                                   width: Constants.cardWidth / 2,
                                   height: Constants.cardHeight / 6)
            let accessoryRect = CGRect(x: Constants.cardWidth * Constants.accessoryRectXMultiplier,
                                       y: Constants.cardHeight * 3 / 4,
                                       width: Constants.cardWidth / 4,
                                       height: Constants.cardHeight / 8)
            if let shoes = itemForLayer(.shoes) {
                if let processed = CollageBuilder.shared.processImage(shoes.image) {
                    processed.draw(in: shoesRect)
                }
            }
            if let accessory = itemForLayer(.accessory) {
                if let processed = CollageBuilder.shared.processImage(accessory.image) {
                    processed.draw(in: accessoryRect)
                }
            }
        }
    }
}

#Preview {
    OutfitCardView(collage: OutfitCollage(
        image: UIImage(systemName: "tshirt.fill")!,
        itemIDs: [UUID()]
    ))
    .padding()
    .background(Color.gray.opacity(0.1))
} 
