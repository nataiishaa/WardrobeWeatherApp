import SwiftUI

struct TutorialOverlay: View {
    let message: String
    let position: CGPoint
    let showArrow: Bool
    let showTapIcon: Bool
    let alignment: Alignment
    let highlightFrame: CGRect?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            if let frame = highlightFrame {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.brandPrimary, lineWidth: 2)
                    .background(Color.brandPrimary.opacity(0.2))
                    .frame(width: frame.width, height: frame.height)
                    .position(x: frame.midX, y: frame.midY)
            }
            
            VStack(spacing: 12) {
                if showArrow {
                    Image(systemName: "arrow.down")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                
                if showTapIcon {
                    Image(systemName: "hand.tap.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.brandPrimary)
                    .cornerRadius(8)
            }
            .frame(maxWidth: 200)
            .position(position)
        }
    }
}
