import SwiftUI

struct OutfitCardView: View {
    let collage: OutfitCollage
    
    var body: some View {
        VStack(spacing: 0) {
            // Outfit Image
            Image(uiImage: collage.image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
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
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.brandPrimary.opacity(0.1), lineWidth: 1)
        )
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