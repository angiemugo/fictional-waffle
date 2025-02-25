//
//  DataSourceProtocol.swift
//  WeatherApp
//
//  Created by Angie Mugo on 25/02/2025.
//

import Foundation
import CoreLocation

protocol DataSource {
    func getTodayWeather(location: CLLocationCoordinate2D) async throws -> TodayWeatherModel
    func getWeatherForecast(location: CLLocationCoordinate2D) async throws -> ForecastResponse
}
