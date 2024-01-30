//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import Foundation
import SwiftUI

@MainActor
class WeatherService: ObservableObject {
    @Published var weatherToday: TodayWeatherUIModel?
    @Published var groupedModel = [String: [ForecastUIModel]]()
    @AppStorage("theme") private var theme: Theme?

    let locationManager: LocationManager
    let client: WeatherClient

    init(locationManager: LocationManager, client: WeatherClient) {
        self.locationManager = locationManager
        self.client = client
    }

    var coordinates: (String, String) {
        return ("\(locationManager.lastLocation?.coordinate.latitude ?? 0)", "\(locationManager.lastLocation?.coordinate.longitude ?? 0)")
    }

    func fetchWeatherForecast() async throws {
        let ungroupedForecast = try await client.getWeatherForecast(lat: coordinates.0, lon: coordinates.1)
        let ungroupedUIModel = ungroupedForecast.list.map { $0.toUIModel() }
        groupedModel = Dictionary(grouping: ungroupedUIModel, by: { $0.dayOfWeek })
    }

    func fetchTodayWeather() async throws {
        weatherToday =  try await client.getTodayWeather(lat: coordinates.0, lon: coordinates.1).toUIModel(theme ?? Theme.forest)
    }
}
