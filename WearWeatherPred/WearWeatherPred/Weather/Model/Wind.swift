import Foundation
import UIKit

public struct Wind: Codable {
    public let speed: Double
    public let deg: Int
    
    public init(speed: Double, deg: Int) {
        self.speed = speed
        self.deg = deg
    }
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }
}
