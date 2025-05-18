import SwiftUI

struct OutfitCardView: View {
    let collage: OutfitCollage
    @ObservedObject private var wardrobeVM = WardrobeViewModel.shared
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let width = min(geometry.size.width, 400)
                let height = width * 1.5 
                ZStack {
                    ForEach(layersToDisplay, id: \.id) { item in
                        let layer = item.layer
                        Image(uiImage: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: layer.size.width * (width / 400),
                                   height: layer.size.height * (height / 600))
                            .offset(x: (layer.position.x - 200) * (width / 400),
                                    y: (layer.position.y - 300) * (height / 600))
                            .zIndex(Double(layer.rawValue))
                    }
                }
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 16 * (width / 400)))
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
                    // TODO: Add save/share functionality
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
    }
    
    private var layersToDisplay: [ClothingItem] {
        collage.itemIDs.compactMap { id in
            wardrobeVM.wardrobeItems.first(where: { $0.id == id })
        }.sorted { $0.layer.rawValue < $1.layer.rawValue }
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
