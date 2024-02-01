//
//  TodayWeatherModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import Foundation

struct TodayWeatherModel: Decodable {
    let main: Main
    let name: String
    let weather: [Weather]
    let sys: SysInfo
    let coord: Coordinates

    func toUIModel() -> TodayWeatherUIModel {
        var location = ""
              if let country = sys.country {
                  location = "\(name), \(country)"
              } else {
                  location = name
              }

        return TodayWeatherUIModel(locationName: location,
                                   desc: weather.first?.main ?? "",
                                   min: main.tempMin.toString(),
                                   current: main.temp.toString(),
                                   max: main.tempMax.toString(),
                                   lat: coord.lat,
                                   lon: coord.lon,
                                   isFavorite: false)
    }
}

struct SysInfo: Decodable {
    let country: String?
}

struct Coordinates: Decodable {
    let lat: Double
    let lon: Double
}

struct Weather: Decodable {
    let main: String
    let description: String
}

struct Main: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
}
