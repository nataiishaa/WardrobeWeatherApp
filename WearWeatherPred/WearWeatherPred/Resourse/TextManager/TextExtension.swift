import SwiftUI

// MARK: — Extension Text
extension Text {
    func montserrat(size: CGFloat) -> some View {
        self.font(.custom("Montserrat-Regular", size: size))
    }
}
