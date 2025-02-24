//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI

struct ForecastResponse: Decodable {
    var list: [Forecast]
    var city: City
}

struct Forecast: Decodable {
    let dtTxt: Date
    let main: Main
    let weather: [Weather]
}

struct City: Decodable {
    var coord: Coordinates
}
