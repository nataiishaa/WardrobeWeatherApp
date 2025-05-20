import UIKit

enum Layer: Int, CaseIterable {
    case top = 0
    case bottom = 1
    case outer = 2
    case shoes = 3
    case accessory = 4
    
    var size: CGSize {
        switch self {
        case .top: return CGSize(width: 280, height: 380)
        case .bottom: return CGSize(width: 280, height: 400)
        case .outer: return CGSize(width: 320, height: 480)
        case .shoes: return CGSize(width: 180, height: 120)
        case .accessory: return CGSize(width: 180, height: 180)
        }
    }
    
    var position: CGPoint {
        switch self {
        case .top: return CGPoint(x: 160, y: 140)
        case .bottom: return CGPoint(x: 160, y: 300)
        case .outer: return CGPoint(x: 140, y: 100)
        case .shoes: return CGPoint(x: 180, y: 580)
        case .accessory: return CGPoint(x: 50, y: 250)
        }
    }
}
