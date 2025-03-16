import SwiftUI

import Foundation


struct ClothingCardView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3)) 
                .frame(height: 150)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 100, height: 20)
            
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.4))
                .frame(width: 80, height: 15)
        }
        .padding()
        .frame(width: 160, height: 220)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
