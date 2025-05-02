import SwiftUI

struct BottomBarView: View {

    enum Tab { case outfit, wardrobe }

    let activeTab: Tab
    let openWardrobe:  () -> Void
    let openSettings:  () -> Void
    let addItem:       () -> Void

    var body: some View {
        HStack {
            barButton("cloud",
                      isActive: activeTab == .outfit,
                      action: { if activeTab != .outfit { openWardrobe() } })

            Spacer()

            barButton("tshirt",
                      isActive: activeTab == .wardrobe,
                      action: { if activeTab != .wardrobe { openWardrobe() } })

            Spacer()

            barButton("slider.horizontal.3",
                      isActive: false,
                      action: openSettings)

            Spacer()

            barButton("plus",
                      isActive: false,
                      action: addItem)
        }
        .padding()
        .frame(height: 50)
        .background(Color.brandPrimary)
        .clipShape(Capsule())
        .foregroundColor(.white)
        .padding(.horizontal, 16)
    }

    // MARK: helper
    @ViewBuilder
    private func barButton(_ system: String,
                           isActive: Bool,
                           action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .resizable().scaledToFit()
                .frame(width: 22, height: 22)
                .padding(12)
                .background(
                    Circle().fill(isActive ? Color.white.opacity(0.30) : .clear)
                )
                .opacity(isActive ? 0.65 : 1.0)
        }
    }
}
