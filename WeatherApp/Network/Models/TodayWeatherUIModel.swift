//
//  TodayWeatherUIModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI
import CoreLocation
import SwiftData

@Model class TodayWeatherUIModel {
    @Attribute(.unique) var locationName: String
    var desc: String
    var min: String
    var current: String
    var max: String
    var lat: Double
    var lon: Double

    init(locationName: String, desc: String, min: String, current: String, max: String, lat: Double, lon: Double) {
        self.locationName = locationName
        self.desc = desc
        self.min = min
        self.current = current
        self.max = max
        self.lat = lat
        self.lon = lon
    }
}

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
