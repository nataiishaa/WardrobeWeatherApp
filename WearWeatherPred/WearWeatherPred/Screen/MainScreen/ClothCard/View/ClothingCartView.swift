import SwiftUI
import Foundation

struct ClothingCardView: View {
    let item: ClothingItem
    
    // Fixed dimensions for the card
    private let cardWidth: CGFloat = 100
    private let cardHeight: CGFloat = 140

    var body: some View {
        VStack(spacing: 8) {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(width: cardWidth - 16, height: cardHeight - 60)
                .cornerRadius(8)

            Text(item.title)
                .montserrat(size: 14).bold()
                .foregroundColor(.black)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: cardWidth - 16)
        }
        .frame(width: .infinity, height: cardHeight)
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
