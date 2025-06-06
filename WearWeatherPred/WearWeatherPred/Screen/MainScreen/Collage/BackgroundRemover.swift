import UIKit
import CoreML
import Vision

class BackgroundRemover {
    static let shared = BackgroundRemover()
    private var model: VNCoreMLModel?
    
    private init() {
        loadModel()
    }
    
    private func loadModel() {
        guard let modelURL = Bundle.main.url(forResource: "DeepLabV3", withExtension: "mlmodel") else {
            print("Failed to find DeepLabV3 model in bundle")
            return
        }
        
        do {
            let compiledModelURL = try MLModel.compileModel(at: modelURL)
            let model = try MLModel(contentsOf: compiledModelURL)
            self.model = try VNCoreMLModel(for: model)
        } catch {
            print("Error loading DeepLabV3 model: \(error)")
        }
    }
    
    func removeBackground(from image: UIImage) -> UIImage? {
        guard let model = model, let cgImage = image.cgImage else {
            return image 
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                print("Vision ML request error: \(error)")
                return
            }
        }
        
        request.imageCropAndScaleOption = .scaleFit
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
        
        guard let results = request.results as? [VNCoreMLFeatureValueObservation],
              let segmentationMap = results.first?.featureValue.multiArrayValue else {
            return image
        }
        
        return createMaskedImage(from: image, segmentationMap: segmentationMap)
    }
    
    private func createMaskedImage(from image: UIImage, segmentationMap: MLMultiArray) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        
        var rawData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        guard let context = CGContext(data: &rawData,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: bitsPerComponent,
                                    bytesPerRow: bytesPerRow,
                                    space: CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let maskWidth = segmentationMap.shape[0].intValue
        let maskHeight = segmentationMap.shape[1].intValue
        
        let scaleX = Double(maskWidth) / Double(width)
        let scaleY = Double(maskHeight) / Double(height)
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = y * width + x
                let dataIndex = pixelIndex * bytesPerPixel
                
                let maskX = Int(Double(x) * scaleX)
                let maskY = Int(Double(y) * scaleY)
                let maskIndex = maskY * maskWidth + maskX
                
                guard maskIndex < maskWidth * maskHeight else { continue }
                
                let segmentationValue = segmentationMap[maskIndex].intValue
                
                if segmentationValue == 0 {
                    rawData[dataIndex] = 0     
                    rawData[dataIndex + 1] = 0
                    rawData[dataIndex + 2] = 0
                    rawData[dataIndex + 3] = 0
                }
            }
        }
        
        guard let maskedCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: maskedCGImage)
    }
} 
