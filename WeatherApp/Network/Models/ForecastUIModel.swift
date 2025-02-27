//
//  ForecastUIModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI
import SwiftData

@Model
final class ForecastUIModel {
    @Attribute(.unique) var id = UUID().uuidString
    var dayOfWeek: String
    var weather: String
    var temp: Double
    var dtTxt: Date
    var latitude: Double
    var longitude: Double

    init(weather: String, dayOfWeek: String, temp: Double, dtTxt: Date, location: Coordinates) {
        self.dayOfWeek = dayOfWeek
        self.weather = weather
        self.temp = temp
        self.dtTxt = dtTxt
        self.latitude = location.lat
        self.longitude = location.lon
    }
    
    convenience init(from fetched: Forecast, city: City) {
        self.init(weather: fetched.weather.first?.main ?? "",
                  dayOfWeek: fetched.dtTxt.getDay(),
                  temp: fetched.main.temp,
                  dtTxt: fetched.dtTxt,
                  location: city.coord
        )
    }
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
