import Foundation
import UIKit

struct Wind: Codable {
    let speed: Double
    let deg: Int
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }
}
