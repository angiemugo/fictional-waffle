//
//  TodayWeatherUIModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI

extension TodayWeatherModel {
    func toUIModel() -> TodayWeatherUIModel {
        return TodayWeatherUIModel(locationName: "\(name), \(sys.country)",
            backgroundImage: BackgroundImage(rawValue: weather.first?.main ?? "")?.background ?? Image(systemName: "clouds"),
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
    case sunny
    case cloudy = "clouds"
    case rainy

    var background: Image {
        switch self {
        case .sunny:
            return Image("forest_sunny")
        case .cloudy:
            return Image("forest_cloudy")
        case .rainy:
            return Image("forest_rainy")
        }
    }
}
