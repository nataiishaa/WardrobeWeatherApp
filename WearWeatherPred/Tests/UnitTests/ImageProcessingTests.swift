import XCTest
@testable import WearWeatherPred
import UIKit
import Vision

final class ImageProcessingTests: XCTestCase {
    
    func testUIImageInitWithPixelBuffer() {
        let maskBuffer = createTestMaskBuffer()
        
        let image = UIImage(pixelBuffer: maskBuffer)
        
        XCTAssertNotNil(image, "Image should be created from pixel buffer")
    }
    
    private func createTestMaskBuffer() -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer?
        let width = 100
        let height = 100
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            nil,
            &pixelBuffer
        )
        
        XCTAssertEqual(status, kCVReturnSuccess, "Should create pixel buffer successfully")
        XCTAssertNotNil(pixelBuffer, "Pixel buffer should not be nil")
        
        return pixelBuffer!
    }
} 
