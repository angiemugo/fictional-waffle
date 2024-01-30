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
    @Published private var groupedModel = [String: [ForecastUIModel]]()

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
        var ungroupedUIModel = ungroupedForecast.list.map { $0.toUIModel() }
        var grouped = Dictionary(grouping: ungroupedUIModel, by: { $0.dayOfWeek })

    }

    func fetchTodayWeather() async throws {
        weatherToday =  try await client.getTodayWeather(lat: coordinates.0, lon: coordinates.1).toUIModel()
    }
}
