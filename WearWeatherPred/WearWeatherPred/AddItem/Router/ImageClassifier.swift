import Vision
import CoreML
import UIKit
import SwiftUI

class ImageClassifier {
    static let shared = ImageClassifier()

    private var model: VNCoreMLModel?

    init() {
        do {
            let mlModel = try MobileNetV2(configuration: MLModelConfiguration()).model
            self.model = try VNCoreMLModel(for: mlModel)
        } catch {
            print("Error loading model: \(error)")
        }
    }

    func classify(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let model = model, let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }

        let request = VNCoreMLRequest(model: model) { request, _ in
            if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                completion(topResult.identifier)
            } else {
                completion(nil)
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            completion(nil)
        }
    }
}

