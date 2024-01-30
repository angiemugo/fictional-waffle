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
                               weather: WeatherIcons(rawValue: weather.first?.main ?? "")?.icon ?? Image(systemName: "cloud"),
                               temp: main.temp.toString(),
                               dtTxt: dtTxt)
    }
}

struct ForecastUIModel {
    let dayOfWeek: String
    let weather: Image
    let temp: String
    let dtTxt: Date
}

enum WeatherIcons: String {
    case clear
    case rain
    case none

    static func create(rawValue: String) -> Self {
        if let icon = WeatherIcons(rawValue: rawValue) {
            return icon
        } else {
            return .none
        }
    }

    var icon: Image {
        switch self {
        case .clear:
            return Image("clear")
        case .rain:
            return Image("rain")
        case .none:
            return Image(systemName: "cloud")
        }
    }
}
