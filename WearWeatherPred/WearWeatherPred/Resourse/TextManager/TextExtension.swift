import SwiftUI
// MARK: — Extension Text
extension Text {
    /// Применяет Montserrat, сохраняя переданный размер
    func montserrat(size: CGFloat) -> some View {
        self.font(.custom("Montserrat-Regular", size: size))
    }
}
