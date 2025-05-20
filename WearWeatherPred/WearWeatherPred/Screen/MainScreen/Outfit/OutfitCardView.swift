import SwiftUI

struct OutfitCardView: View {
    let collage: OutfitCollage
    @ObservedObject private var wardrobeVM = WardrobeViewModel.shared
    @State private var isSharePresented = false
    @State private var shareImage: UIImage?
    
    // Constants for layout
    private let cardWidth: CGFloat = 400
    private let cardHeight: CGFloat = 600
    private let horizontalSpacing: CGFloat = 20
    private let verticalSpacing: CGFloat = 30
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let width = min(geometry.size.width, cardWidth)
                let height = width * 1.5 
                
                // Сетка: верх, низ, обувь+аксессуар
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
                .clipShape(RoundedRectangle(cornerRadius: 16 * (width / cardWidth)))
            }
            .aspectRatio(2/3, contentMode: .fit)
            
            // Card Footer
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
                        .padding(8)
                        .background(Color.brandPrimary.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.brandPrimary.opacity(0.1), lineWidth: 1)
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
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: cardWidth, height: cardHeight))
        return renderer.image { context in
            // Draw white background
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: CGSize(width: cardWidth, height: cardHeight)))

            // Верхняя одежда
            if let outer = itemForLayer(.outer) {
                if let processed = CollageBuilder.shared.processImage(outer.image) {
                    let rect = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight / 4)
                    processed.draw(in: rect)
                }
            }
            // Верх
            if let top = itemForLayer(.top) {
                if let processed = CollageBuilder.shared.processImage(top.image) {
                    let rect = CGRect(x: 0, y: cardHeight / 4, width: cardWidth, height: cardHeight / 4)
                    processed.draw(in: rect)
                }
            }
            // Низ
            if let bottom = itemForLayer(.bottom) {
                if let processed = CollageBuilder.shared.processImage(bottom.image) {
                    let rect = CGRect(x: 0, y: cardHeight / 2, width: cardWidth, height: cardHeight / 4)
                    processed.draw(in: rect)
                }
            }
            // Обувь и аксессуар
            let shoesRect = CGRect(x: 0, y: cardHeight * 3 / 4, width: cardWidth / 2, height: cardHeight / 6)
            let accessoryRect = CGRect(x: cardWidth * 0.6, y: cardHeight * 3 / 4, width: cardWidth / 4, height: cardHeight / 8)
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

// Вспомогательная вью для удаления фона
struct ProcessedImageView: View {
    let image: UIImage
    @State private var processed: UIImage?

    var body: some View {
        Group {
            if let processed = processed {
                Image(uiImage: processed)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let result = CollageBuilder.shared.processImage(image)
                            DispatchQueue.main.async {
                                self.processed = result
                            }
                        }
                    }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    OutfitCardView(collage: OutfitCollage(
        image: UIImage(systemName: "tshirt.fill")!,
        itemIDs: [UUID()]
    ))
    .padding()
    .background(Color.gray.opacity(0.1))
} 
