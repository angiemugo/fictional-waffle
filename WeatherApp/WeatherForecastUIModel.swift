//
//  WeatherForecastUIModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI

extension Forecast {
    func toUIModel() -> ForecastUIModel {
        return ForecastUIModel(dayOfWeek: dtTxt.getDay(),
                               weather: WeatherIcons(rawValue: weather.first?.main ?? "")?.icon ?? Image(systemName: "clouds"),
                               temp: main.temp.toString())
    }
}

struct ForecastUIModel {
    let dayOfWeek: String
    let weather: Image
    let temp: String
}

enum WeatherIcons: String {
    case clear
    case rain

    var icon: Image {
        switch self {
        case .clear:
            return Image("clear")
        case .rain:
            return Image("rain")
        }
    }
}
