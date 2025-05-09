//
//  Cloth.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 09.05.2025.
//

import SwiftUI
import UIKit

struct ClothingItemDTO: Codable {
    let id: UUID
    let title: String
    let category: String?
    let season: String?
    let type: String?
    let imageFilename: String
}
