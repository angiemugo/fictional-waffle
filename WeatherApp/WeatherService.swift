//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation


@MainActor
class WeatherService: ObservableObject {
    @Published var weatherToday: TodayWeatherUIModel?
    @Published var groupedModel = [String: [ForecastUIModel]]()
    @Published var alertError: WeatherClientError?

    let dataSource: RemoteDataSource

    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }

    func fetchWeatherForecast(_ lat: String, _ lon: String) async throws {
        let ungroupedForecast = try await dataSource.getWeatherForecast(lat: lat.description, lon: lon.description)
        let ungroupedUIModel = ungroupedForecast.list.map { $0.toUIModel() }
        groupedModel = Dictionary(grouping: ungroupedUIModel, by: { $0.dayOfWeek })
    }

    func fetchTodayWeather(_ lat: String, _ lon: String) async throws {
        weatherToday =  try await dataSource.getTodayWeather(lat: lat, lon: lon).toUIModel()
    }

    func onAppearAction(_ location: CLLocation) async {
        do {
            try await fetchTodayWeather(location.coordinate.latitude.description, location.coordinate.longitude.description)
            try await fetchWeatherForecast(location.coordinate.latitude.description, location.coordinate.longitude.description)
        } catch {
            extractError(error)
        }
    }

    func extractError(_ error: Error) {
        let clientError = NetworkClientHelpers.extractError(response: nil, error: error)
        alertError = clientError
    }
}
