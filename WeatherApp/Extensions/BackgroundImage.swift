//
//  TodayWeatherUIModel+Weather.swift
//  WeatherApp
//
//  Created by Angie Mugo on 21/02/2025.
//
import Foundation

enum BackgroundImage: String {
    case sunny
    case cloudy = "Clouds"
    case rainy  = "rain"
    case seaSunny
    case seaCloudy
    case seaRainy
    case none

    static func create(rawValue: String) -> Self {
        if let bgImage = BackgroundImage(rawValue: rawValue) {
            return bgImage
        } else {
            return .none
        }
    }

    var background: String {
        switch self {
        case .sunny:
            return "forest_sunny"
        case .cloudy:
            return "forest_cloudy"
        case .rainy:
            return "forest_rainy"
        case .seaSunny:
            return "sea_sunny"
        case .seaCloudy:
            return "sea_cloudy"
        case .seaRainy:
            return "sea_rainy"
        case .none:
            return "forest_sunny"
        }
    }
}
