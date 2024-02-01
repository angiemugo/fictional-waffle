//
//  RemoteDataSource.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import Foundation

protocol DataSource {
    func getTodayWeather(lat: String, lon: String, units: String) async throws -> TodayWeatherModel
        func getWeatherForecast(lat: String, lon: String, units: String) async throws -> ForecastResponse
}

class RemoteDataSource {
    let networkClient: NetworkClient
    let urlBuilder: URLBuilder
    let headers:  Network.HTTPHeaders

    init(_ client: WeatherClient) {
        self.urlBuilder = client.urlBuilder
        self.networkClient = client.networkClient
        self.headers = client.headers()
    }

    func getTodayWeather(lat: String, lon: String, units: String = "metric") async throws -> TodayWeatherModel {
        let result: TodayWeatherModel =  try await networkClient.get(urlBuilder.url(path: WeatherClientPaths.Today,
                                                          params: ["lat": lat,
                                                                   "lon": lon,
                                                                   // fix me: don't put this in here
                                                                   "appid": "431c22806f9ef4fbe4f7d5f273c41cf7",
                                                                   "units": units]),
                                           headers: headers)
        return result
    }

    func getWeatherForecast(lat: String, lon: String, units: String = "metric") async throws -> ForecastResponse {
        return try await networkClient.get(urlBuilder.url(path: WeatherClientPaths.Forecast,
                                                          params: ["lat": lat,
                                                                   "lon": lon,
                                                                   // fix me: don't put this in here
                                                                   "appid": "431c22806f9ef4fbe4f7d5f273c41cf7",
                                                                   "units": units]),
                                           headers: headers)
    }
}
