//
//  FavoriteViewModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import Foundation
import CoreLocation
import SwiftData

class FavoriteViewModel: ObservableObject {
    enum State {
          case empty
          case loading
          case failed(Error)
          case loaded(TodayWeatherUIModel)
      }

    @Published var locationManager = LocationManager.shared
    @Published private(set) var state = State.empty
    @Published var fetchedLocations = [TodayWeatherUIModel]()

    let dataSource: RemoteDataSource

    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }

    func fetchTodayWeather(_ lat: Double, _ lon: Double) async throws -> TodayWeatherUIModel {
        return try await dataSource.getTodayWeather(lat: lat.description, lon: lon.description).toUIModel()
    }

    func fetchCurrentLocation(_ lat: Double, _ lon: Double) async throws -> TodayWeatherUIModel {
        return try await fetchTodayWeather(lat, lon)
    }

    func refreshSavedLocations(_ savedLocations: [TodayWeatherUIModel]) async throws  {
        try await withThrowingTaskGroup(of: TodayWeatherModel.self) { group in
            var fetchedLoc = [TodayWeatherUIModel]()
            for location in savedLocations {
                let fetched = try await fetchTodayWeather(location.lat, location.lon)
                fetchedLoc.append(fetched)
            }
            fetchedLocations = fetchedLoc
        }

    }

    func onAppearAction(_ location: CLLocation) async {
        state = .loading
            do {
                let today = try await dataSource.getTodayWeather(lat: location.coordinate.latitude.description, lon: location.coordinate.latitude.description).toUIModel()
                state = .loaded(today)
            } catch {
                state = .failed(error)
            }
    }
}
