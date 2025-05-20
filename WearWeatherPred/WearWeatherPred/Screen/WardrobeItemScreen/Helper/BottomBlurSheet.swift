import SwiftUI

struct BottomBlurSheet<Content: View>: View {
    let heightFactor: CGFloat
    let content: Content
    init(heightFactor: CGFloat = 0.5,
         @ViewBuilder content: () -> Content) {
        self.heightFactor = heightFactor
        self.content = content()
    }
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(.thinMaterial)
                .opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
            
            VStack { Spacer()
                content
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * heightFactor)
                    .background(Color.brandPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 32,
                                                style: .continuous))
                    .ignoresSafeArea(edges: .bottom)
            }
            .transition(.move(edge: .bottom))
            .animation(.easeOut(duration: 0.25), value: UUID())
        }
    }
    private func dismiss() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
