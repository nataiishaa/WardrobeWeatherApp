//
//  ClothingItem.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import Foundation

struct ClothingItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let itemCount: Int
}

enum OutfitCategory: String, CaseIterable {
    case casual = "Casual"
    case daily = "Daily"
    case party = "Party"
}
