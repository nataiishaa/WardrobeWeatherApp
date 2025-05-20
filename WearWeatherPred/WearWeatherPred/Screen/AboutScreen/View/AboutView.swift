import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: Constants.vStackSpacing) {
                Image(systemName: Constants.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    .foregroundColor(.brandPrimary)
                
                Text(Constants.appName)
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: Constants.innerVStackSpacing) {
                    Text(Constants.aboutDeveloperTitle)
                        .font(.headline)
                    
                    Text(Constants.developerDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: Constants.contactVStackSpacing) {
                        Text(Constants.contactTitle)
                            .font(.headline)
                        
                        Link(destination: URL(string: Constants.telegramURL)!) {
                            HStack {
                                Image(systemName: Constants.paperplaneIcon)
                                    .foregroundColor(.brandPrimary)
                                Text(Constants.telegramHandle)
                                    .foregroundColor(.brandPrimary)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(Constants.cornerRadius)
                .shadow(radius: Constants.shadowRadius)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Constants.doneButtonTitle) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private enum Constants {
        static let vStackSpacing: CGFloat = 20
        static let innerVStackSpacing: CGFloat = 15
        static let contactVStackSpacing: CGFloat = 10
        
        static let imageName = "tshirt.fill"
        static let imageWidth: CGFloat = 100
        static let imageHeight: CGFloat = 100
        
        static let appName = "WearWeather"
        static let aboutDeveloperTitle = "About Developer"
        static let developerDescription = "This app was developed by Natalia Zaharova, iOS developer"
        
        static let contactTitle = "Contact"
        static let telegramURL = "https://t.me/nataishaa"
        static let telegramHandle = "@nataishaa"
        static let paperplaneIcon = "paperplane.fill"
        
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 2
        
        static let doneButtonTitle = "Done"
    }
}

#Preview {
    AboutView()
} 
