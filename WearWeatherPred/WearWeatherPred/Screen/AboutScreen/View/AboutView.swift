import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "tshirt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.brandPrimary)
                
                Text("WearWeather")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("About Developer")
                        .font(.headline)
                    
                    Text("This app was developed by Natalia Zaharova, iOS developer")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Contact")
                            .font(.headline)
                        
                        Link(destination: URL(string: "https://t.me/nataishaa")!) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.brandPrimary)
                                Text("@nataishaa")
                                    .foregroundColor(.brandPrimary)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AboutView()
} 
