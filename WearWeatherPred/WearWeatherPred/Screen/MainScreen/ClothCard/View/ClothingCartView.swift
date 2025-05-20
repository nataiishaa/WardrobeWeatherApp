import SwiftUI
import Foundation

struct ClothingCardView: View {
    let item: ClothingItem
    
    var body: some View {
        VStack(spacing: Constants.vStackSpacing) {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.cardImageWidth, height: Constants.cardImageHeight)
                .cornerRadius(Constants.imageCornerRadius)
            
            Text(item.title)
                .montserrat(size: Constants.titleFontSize).bold()
                .foregroundColor(.black)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: Constants.titleFrameWidth)
        }
        .frame(maxWidth: .infinity, maxHeight: Constants.cardHeight)
        .padding(Constants.outerPadding)
        .background(Color.white)
        .cornerRadius(Constants.cardCornerRadius)
        .shadow(radius: Constants.shadowRadius)
    }
    
    private enum Constants {
        static let cardWidth: CGFloat = 100
        static let cardHeight: CGFloat = 140
        
        static let vStackSpacing: CGFloat = 8
        
        static let cardImageWidth = cardWidth - 16
        static let cardImageHeight = cardHeight - 60
        static let imageCornerRadius: CGFloat = 8
        
        static let titleFontSize: CGFloat = 14
        static let titleFrameWidth = cardWidth - 16
        
        static let outerPadding: CGFloat = 8
        static let cardCornerRadius: CGFloat = 10
        static let shadowRadius: CGFloat = 3
    }
}
