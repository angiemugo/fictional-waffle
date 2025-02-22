//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import Foundation
import CoreLocation
import SwiftData

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    let dataSource: RemoteDataSource
    var searchText: String = ""
    var errorText: String? {
        didSet { showAlert = errorText != nil }
    }

    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }

    // MARK: - Public Methods

    func fetchCurrentWeather(for location: CLLocation?,
                             locationStatus: CLAuthorizationStatus?,
                             modelContext: ModelContext) async {
        guard locationStatus != .denied else {
            handleError(WeatherClientError.locationError(message: ErrorMessages.locationAccessDenied.rawValue))
            return
        }
        guard let location = location else { return }

        do {
            let weatherModel = try await fetchTodayWeather(location: location.coordinate, modelContext: modelContext, isCurrent: true)
            insertModels([weatherModel], modelContext: modelContext)
        } catch {
            handleError(error)
        }
    }

    func fetchSavedLocationsWeather(for locations: [CLLocationCoordinate2D], modelContext: ModelContext) async {
        do {
            let weatherModels = try await locations.asyncMap {
                try await self.fetchTodayWeather(location: $0, modelContext: modelContext, isCurrent: false)
            }
            insertModels(weatherModels, modelContext: modelContext)
        } catch {
            handleError(error)
        }
    }

    func fetchWeatherForecast(location: CLLocationCoordinate2D, modelContext: ModelContext) async {
        do {
            let forecast = try await dataSource.getWeatherForecast(location: location)
            let UIModels = forecast.list.map(ForecastUIModel.init)
            insertModels(UIModels, modelContext: modelContext)
        } catch {
            handleError(error)
        }
    }

    func saveLocation(location: CLLocationCoordinate2D, modelContext: ModelContext) {
        Task {
            do {
                let model = try await fetchTodayWeather(location: location, modelContext: modelContext, isCurrent: false)
                insertModels([model], modelContext: modelContext)
            } catch {
                handleError(error)
            }
        }
    }

    func deleteLocation(for weatherModel: TodayWeatherUIModel, modelContext: ModelContext) {
        deleteModels([weatherModel], modelContext: modelContext)
    }

    // MARK: - Private Methods

    private func fetchTodayWeather(location: CLLocationCoordinate2D,
                                   modelContext: ModelContext,
                                   isCurrent: Bool) async throws -> TodayWeatherUIModel {
        let weather = try await dataSource.getTodayWeather(location: location)
        return TodayWeatherUIModel(from: weather, isCurrentLocation: isCurrent)
    }

    private func insertModels<T: PersistentModel>(_ models: [T], modelContext: ModelContext) {
        DebugEnvironment.log.debug("\(LogMessages.insertingModels.rawValue)\(models)")
        models.forEach { modelContext.insert($0) }
        saveContext(modelContext)
    }

    private func deleteModels<T: PersistentModel>(_ models: [T], modelContext: ModelContext) {
        DebugEnvironment.log.debug("\(LogMessages.deletingModels.rawValue)\(models)")
        models.forEach { modelContext.delete($0) }
        saveContext(modelContext)
    }

    private func saveContext(_ modelContext: ModelContext) {
        do {
            DebugEnvironment.log.debug(LogMessages.savingContext.rawValue)
            try modelContext.save()
        } catch {
            DebugEnvironment.log.debug("\(LogMessages.errorSavingContext.rawValue)\(error)")
        }
    }

    private func handleError(_ error: Error) {
        if let weatherError = error as? WeatherClientError {
            errorText = weatherError.errorMessage
        } else {
            errorText = String(format: ErrorMessages.errorEncountered.rawValue, error.localizedDescription)
        }
    }
}
