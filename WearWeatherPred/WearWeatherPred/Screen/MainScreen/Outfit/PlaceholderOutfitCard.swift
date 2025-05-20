import SwiftUI

struct PlaceholderOutfitCard: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 100)
                .cornerRadius(8)

            Text("Autumn outfit")
                .montserrat(size: 16).bold()

            Text("6 items")
                .montserrat(size: 16).bold()
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
