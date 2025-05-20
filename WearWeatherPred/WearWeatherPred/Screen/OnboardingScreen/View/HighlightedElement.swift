import SwiftUI

struct HighlightedElement: View {
    let message: String
    let position: CGPoint
    let size: CGSize
    
    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(8)
                .background(Color.brandPrimary)
                .cornerRadius(8)
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.brandPrimary, lineWidth: 2)
                .frame(width: size.width, height: size.height)
                .background(Color.brandPrimary.opacity(0.2))
        }
        .position(position)
    }
}

