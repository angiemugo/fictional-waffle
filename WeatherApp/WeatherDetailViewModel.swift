//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation


@MainActor
class WeatherDetailViewModel: ObservableObject {
    enum State {
          case idle
          case loading
          case failed(Error)
          case loaded([String: [ForecastUIModel]])
      }

    @Published private(set) var state = State.idle
    @Published var locationManager = LocationManager.shared

    let dataSource: RemoteDataSource

    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }

    func fetchWeatherForecast(_ lat: Double, _ lon: Double) async throws -> [String: [ForecastUIModel]]{
        let ungroupedForecast = try await dataSource.getWeatherForecast(lat: lat.description, lon: lon.description)
        let ungroupedUIModel = ungroupedForecast.list.map { $0.toUIModel() }
        return Dictionary(grouping: ungroupedUIModel, by: { $0.dayOfWeek })
    }


    func onAppearAction(_ lat: Double, _ lon: Double) async {
        state = .loading
            do {
                let forecast = try await fetchWeatherForecast(lat, lon)
                state = .loaded(forecast)

            } catch {
                state = .failed(error)
            }
    }
}
