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
}

struct SysInfo: Decodable {
    let country: String?
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

