import SwiftUI

struct BottomBarView: View {
    
    enum Tab { case outfit, wardrobe }
    
    let activeTab: Tab
    let openWardrobe: () -> Void
    let openSettings: () -> Void
    let addItem: () -> Void
    
    var body: some View {
        HStack {
            barButton(Constants.iconCloud,
                      isActive: activeTab == .outfit,
                      action: { if activeTab != .outfit { openWardrobe() } })
            
            Spacer()
            
            barButton(Constants.iconTshirt,
                      isActive: activeTab == .wardrobe,
                      action: { if activeTab != .wardrobe { openWardrobe() } })
            
            Spacer()
            
            barButton(Constants.iconSettings,
                      isActive: false,
                      action: openSettings)
            
            Spacer()
            
            barButton(Constants.iconPlus,
                      isActive: false,
                      action: addItem)
        }
        .padding()
        .frame(height: Constants.frameHeight)
        .background(Color.brandPrimary)
        .clipShape(Capsule())
        .foregroundColor(.white)
        .padding(.horizontal, Constants.horizontalPadding)
    }
    
    // MARK: - helper
    
    @ViewBuilder
    private func barButton(_ system: String,
                           isActive: Bool,
                           action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.iconSize, height: Constants.iconSize)
                .padding(Constants.iconPadding)
                .background(
                    Circle().fill(isActive ? Color.white.opacity(Constants.activeBackgroundOpacity) : .clear)
                )
                .opacity(isActive ? Constants.activeOpacity : 1.0)
        }
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let iconCloud = "cloud"
        static let iconTshirt = "tshirt"
        static let iconSettings = "slider.horizontal.3"
        static let iconPlus = "plus"
        
        static let iconSize: CGFloat = 22
        static let iconPadding: CGFloat = 12
        
        static let frameHeight: CGFloat = 50
        static let horizontalPadding: CGFloat = 16
        
        static let activeBackgroundOpacity = 0.30
        static let activeOpacity = 0.65
    }
}
