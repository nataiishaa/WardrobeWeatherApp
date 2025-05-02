//
//  AppViewRouter.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 01.05.2025.
//

// AppViewRouter.swift
import SwiftUI
import UIKit

final class AppViewRouter: ObservableObject {

    enum Tab {
        case home        
        case wardrobe
        case settings
    }

    @Published var tab: Tab = .home
}
