//
//  FavoriteViewModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import Foundation
import CoreLocation
import SwiftData

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var locationManager = LocationManager.shared
    @Published private(set) var fetchedLocations = [TodayWeatherUIModel]()
    @Published private(set) var currentLocation: TodayWeatherUIModel?
    @Published var showAlert = false

    private(set) var errorString: String = "" {
        didSet {
            showAlert = errorString == ""
        }
    }

    let dataSource: RemoteDataSource

    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }

    func fetchTodayWeather(_ lat: Double, _ lon: Double) async throws -> TodayWeatherUIModel {
        return try await dataSource.getTodayWeather(lat: lat.description, lon: lon.description).toUIModel()
    }

    func fetchForSaved(_ lat: Double, _ lon: Double) async {
        do {
            let location = try await fetchTodayWeather(lat, lon)
            fetchedLocations.append(location)
        } catch {
            errorString = error.localizedDescription
        }
    }

    func fetchCurrentLocation(_ lat: Double, _ lon: Double) async {
        do {
            let location = try await fetchTodayWeather(lat, lon)
            currentLocation = location
        } catch {
            errorString = error.localizedDescription
        }
    }

    func refreshSavedLocations(_ savedLocations: [TodayWeatherUIModel]) async  {
        do {
            try await withThrowingTaskGroup(of: TodayWeatherModel.self) { group in
                var fetchedLoc = [TodayWeatherUIModel]()
                for location in savedLocations {
                    let fetched = try await fetchTodayWeather(location.lat, location.lon)
                    fetchedLoc.append(fetched)
                }
                fetchedLocations = fetchedLoc
            }
        } catch {
            errorString = error.localizedDescription
        }
    }
}
