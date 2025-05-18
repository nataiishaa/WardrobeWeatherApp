import Foundation
import CoreML
import Vision
import UIKit

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
    let wind: Wind
    
    var temperature: Double {
        return main.temp
    }
    
    var isRaining: Bool {
        return weather.contains { $0.main.lowercased().contains("rain") }
    }
    
    var isWindy: Bool {
        return wind.speed > 5.0 // Consider it windy if wind speed is more than 5 m/s
    }
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case name
        case wind
    }
}

func removeBackgroundWithCoreML(image: UIImage, completion: @escaping (UIImage?) -> Void) {
    guard let cgImage = image.cgImage else { completion(nil); return }
    let model = try! VNCoreMLModel(for: DeepLabV3().model)
    let request = VNCoreMLRequest(model: model) { request, error in
        guard let results = request.results as? [VNPixelBufferObservation],
              let mask = results.first?.pixelBuffer else {
            completion(nil)
            return
        }
        let output = image.applyMask(mask: mask)
        completion(output)
    }
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    try? handler.perform([request])
}

extension UIImage {
    func applyMask(mask: CVPixelBuffer) -> UIImage? {
        let maskImage = UIImage(pixelBuffer: mask)
        guard let maskCgImage = maskImage?.cgImage,
              let cgImage = self.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.clip(to: CGRect(x: 0, y: 0, width: width, height: height), mask: maskCgImage)
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    convenience init?(pixelBuffer: CVPixelBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        self.init(cgImage: cgImage)
    }
}
