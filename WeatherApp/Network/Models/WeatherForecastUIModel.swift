//
//  WeatherForecastUIModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI
import SwiftData

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

enum WeatherColor: String {
    case cloudy = "Clouds"
    case sunny
    case rainy = "rain"
    case none

    static func create(rawValue: String) -> Self {
        if let color = WeatherColor(rawValue: rawValue) {
            return color
        } else {
            return .none
        }
    }

    var color: Color {
        switch self {
        case .cloudy:
            return Color(hex: "54717A")
        case .sunny:
            return Color(hex: "47AB2F")
        case .rainy:
            return Color(hex: "57575D")
        case .none:
            return Color(hex: "47AB2F")

        }

    }
}
