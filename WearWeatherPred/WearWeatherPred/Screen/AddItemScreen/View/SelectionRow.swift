import SwiftUI

struct SelectionRow: View {
    let options: [String]
    let selected: String
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: Constants.hStackSpacing) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    onSelect(option)
                }) {
                    Text(option.capitalized)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.vertical, Constants.verticalPadding)
                        .background(selected == option ? Color(Constants.cardAccentColor) : Color.white)
                        .foregroundColor(selected == option ? .white : .black)
                        .cornerRadius(Constants.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                .stroke(Color.gray.opacity(Constants.strokeOpacity))
                        )
                }
            }
        }
    }

    private enum Constants {
        static let hStackSpacing: CGFloat = 8
        static let verticalPadding: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let strokeOpacity: Double = 0.3
        static let cardAccentColor = "CardAccent"
    }
}
