import SwiftUI
import Foundation

struct ClothingCardView: View {
    let item: ClothingItem

    var body: some View {
        VStack {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .cornerRadius(8)

            Text(item.title)
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
