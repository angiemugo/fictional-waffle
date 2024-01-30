//
//  TodayWeatherUIModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI

extension TodayWeatherModel {
    func toUIModel(_ theme: Theme) -> TodayWeatherUIModel {
        var location = ""
        if let country = sys.country {
            location = "\(name), \(country)"
        } else {
            location = name
        }
        return TodayWeatherUIModel(locationName: location,
                                   backgroundImage: BackgroundImage.create(rawValue: weather.first?.main ?? "", theme: theme.rawValue).background,
                                   min: main.tempMin.toString(),
                                   current: main.temp.toString(),
                                   max: main.tempMax.toString())
    }
}

struct TodayWeatherUIModel {
    let locationName: String
    let backgroundImage: Image
    let min: String
    let current: String
    let max: String
}

enum BackgroundImage: String {
    case forestSunny
    case forestCloudy = "forestClouds"
    case forestRainy
    case seaSunny
    case seaCloudy
    case seaRainy
    case none

    static func create(rawValue: String, theme: String) -> Self {
        let name = "\(theme)\(rawValue.capitalized)"
        if let bgImage = BackgroundImage(rawValue: name) {
            return bgImage
        } else {
            return .none
        }
    }

    var background: Image {
        switch self {
        case .forestSunny:
            return Image("forest_sunny")
        case .forestCloudy:
            return Image("forest_cloudy")
        case .forestRainy:
            return Image("forest_rainy")
        case .seaSunny:
            return Image("sea_sunny")
        case .seaCloudy:
            return Image("sea_cloudy")
        case .seaRainy:
            return Image("sea_rainy")
        case .none:
            return Image(systemName: "cloud")
        }
    }
}
