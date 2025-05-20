import SwiftUI

struct ProcessedImageView: View {
    let image: UIImage
    @State private var processed: UIImage?

    var body: some View {
        Group {
            if let processed = processed {
                Image(uiImage: processed)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let result = CollageBuilder.shared.processImage(image)
                            DispatchQueue.main.async {
                                self.processed = result
                            }
                        }
                    }
            }
        }
    }
}
