import SwiftUI

struct FinalScreen: View {
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.brandPrimary.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Text("Congratulations!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Now you know how to use our app")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 32)
                
                Button("Start") {
                    onDismiss()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            }
        }
    }
}
