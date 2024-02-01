//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI

struct ForecastResponse: Decodable {
    var list: [Forecast]
}

struct Forecast: Decodable {
    let dtTxt: Date
    let main: Main
    let weather: [Weather]

    func toUIModel() -> ForecastUIModel {
        return ForecastUIModel(dayOfWeek: dtTxt.getDay(),
                               weather:
                                WeatherIcons(rawValue: weather.first?.main ?? "")?.icon ?? Image(systemName: "cloud"),
                               temp: main.temp.toString(),
                               dtTxt: dtTxt)
    }
}
