//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import Foundation
import CoreLocation
import SwiftData

enum Status {
    case Loading
    case Loaded(String)
    case Error(String)
    case idle
}

@MainActor
final class WeatherViewModel: ObservableObject {
    let dataSource: RemoteDataSource
    @Published var showAlert: Bool = false
    @Published var status: Status = .idle {
        didSet {
            if case .Loading = status {
                showAlert = false
            } else {
                showAlert = true
            }
        }
    }
    
    var statusText: String? {
        switch status {
        case .Loaded(let message), .Error(let message):
            return message
        default:
            return nil
        }
    }
    
    var isError: Bool {
        if case .Error = status { return true }
        return false
    }
    
    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: - Public Methods
    
    func fetchCurrentWeather(for location: CLLocation,
                             locationStatus: CLAuthorizationStatus?,
                             modelContext: ModelContext) async {
        guard locationStatus != .denied else {
            handleError(WeatherClientError.locationError(message: ErrorMessages.locationAccessDenied.rawValue))
            return
        }
        
        do {
            let weatherModel = try await fetchTodayWeather(location: location.coordinate, modelContext: modelContext, isCurrent: true)
            insertModels([weatherModel], modelContext: modelContext)
            status = .Loaded(AppStrings.weatherFetched.rawValue)
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
            status = .Loaded(AppStrings.savedSuccess.rawValue)
        } catch {
            handleError(error)
        }
    }
    
    func fetchWeatherForecast(location: CLLocationCoordinate2D, modelContext: ModelContext) async {
        do {
            let forecastResponse = try await dataSource.getWeatherForecast(location: location)
            let UIModels = forecastResponse.list.map { ForecastUIModel(from: $0, city: forecastResponse.city) }
            insertModels(UIModels, modelContext: modelContext)
            status = .Loaded(AppStrings.forecastSuccess.rawValue)
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
            status = .Error(weatherError.errorMessage)
        } else {
            status = .Error(String(format: ErrorMessages.errorEncountered.rawValue, error.localizedDescription))
        }
    }
}
