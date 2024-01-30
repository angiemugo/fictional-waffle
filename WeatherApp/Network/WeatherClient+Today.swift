//
//  NetworkClient+Today.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import CoreLocation

extension WeatherClient {
    func getTodayWeather(lat: String, lon: String, units: String = "metric") async throws -> TodayWeatherModel {
        return try await networkClient.get(urlBuilder.url(path: WeatherClientPaths.Today,
                                                          params: ["lat": lat,
                                                                   "lon": lon,
                                                                   // fix me: don't put this in here
                                                                   "appid": "431c22806f9ef4fbe4f7d5f273c41cf7",
                                                                   "units": units]),
                                           headers: headers())
    }
}
