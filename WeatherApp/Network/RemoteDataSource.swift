//
//  RemoteDataSource.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import Foundation
import CoreLocation

protocol DataSource {
    func getTodayWeather(location: CLLocationCoordinate2D) async throws -> TodayWeatherModel
    func getWeatherForecast(location: CLLocationCoordinate2D) async throws -> ForecastResponse
}

class RemoteDataSource: DataSource {
    let networkClient: NetworkClient
    let urlBuilder: URLBuilder
    let headers:  Network.HTTPHeaders
    let apiKey = fetchAuthToken()

    init(client: WeatherClient) {
        self.urlBuilder = client.urlBuilder
        self.networkClient = client.networkClient
        self.headers = client.headers
    }

    func getTodayWeather(location: CLLocationCoordinate2D) async throws -> TodayWeatherModel {
        let parameters = [
            "lat": "\(location.latitude)",
            "lon": "\(location.longitude)",
            "appid": apiKey,
            "units": "metric"
        ]
        let result: TodayWeatherModel =  try await networkClient.get(for: urlBuilder.url(path:
                                                                                            WeatherClientPaths.Today,
                                                                                    params: parameters),
                                                                     headers: headers)
        return result
    }

    func getWeatherForecast(location: CLLocationCoordinate2D) async throws -> ForecastResponse {
        let parameters = [
            "lat": "\(location.latitude)",
            "lon": "\(location.longitude)",
            "appid": apiKey,
            "units": "metric"
        ]

        let result: ForecastResponse =  try await networkClient.get(for: urlBuilder
            .url(path: WeatherClientPaths.Forecast,
                                                                                   params: parameters),
                                                                    headers: headers)
        return result
    }
}
