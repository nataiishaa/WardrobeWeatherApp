
import SwiftUI

struct BottomBarView: View {
    @Binding var isSettingsPresented: Bool
    var body: some View {
        HStack {
            Button(action: {
                // TODO: action
            }) {
                Image(systemName: "cloud")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            Spacer()
            
            Button(action: {
                // TODO: action
            }) {
                Image(systemName: "tshirt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            Spacer()
            
            Button(action: {
                isSettingsPresented = true
            }) {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            Spacer()
            
            Button(action: {
                // TODO: action
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
        .padding()
        .frame(height: 50)
        .background(Color.black.opacity(0.9))
        .clipShape(Capsule())
        .foregroundColor(.white)
        .padding(.horizontal, 16)
    }
}

