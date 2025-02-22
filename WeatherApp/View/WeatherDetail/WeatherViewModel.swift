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
//    let locationService = LocationService.shared
    var searchText: String = ""
    var errorText: String? {
        didSet {
            showAlert = errorText != nil
        }
    }
    @Published var currentLocation: CLLocation?

    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }

//    public func getCurrentLocation() async {
//        do {
//            currentLocation = try await locationService.currentLocation
//        } catch {
//            print("This is the error: \(error)")
//        }
//    }
    public func fetchCurrentWeather(location: CLLocation,
        modelContext: ModelContext) async {
        do {
//            let location = try await locationService.currentLocation
//            currentLocation = location
            let currentWeatherModel: TodayWeatherUIModel = try await fetchTodayWeather(location: location.coordinate,
                                                                                       modelContext: modelContext,
                                                                                       isCurrent: true)
            insertModels([currentWeatherModel], modelContext: modelContext)
        } catch {
            print("This is the error: \(error)")
        }
    }

    func fetchSavedLocationsWeather(for locations: [CLLocation],
                                    modelContext: ModelContext) async {
        do {
            let weatherModels: [TodayWeatherUIModel] = try await locations.asyncMap { location in
                return try await self.fetchTodayWeather(location: location.coordinate, modelContext: modelContext, isCurrent: false)
            }
            insertModels(weatherModels, modelContext: modelContext)
        }  catch let weatherError as WeatherClientError {
            errorText = weatherError.errorMessage
        } catch {
            errorText = "Unexpected error: \(error.localizedDescription)"
        }
    }

    private func fetchTodayWeather(location: CLLocationCoordinate2D,
                                   modelContext: ModelContext,
                                   isCurrent: Bool) async throws -> TodayWeatherUIModel {
        let todayWeather = try await dataSource.getTodayWeather(location: location)
        let UIModel = TodayWeatherUIModel(from: todayWeather, isCurrentLocation: isCurrent)
        return UIModel
    }

    func fetchWeatherForecast(location: CLLocationCoordinate2D, modelContext: ModelContext) async {
        do {
            let forecast = try await dataSource.getWeatherForecast(location: location)
            let UIModels = forecast.list.map { ForecastUIModel(from: $0) }
            insertModels(UIModels, modelContext: modelContext)
        }  catch let weatherError as WeatherClientError {
            errorText = weatherError.errorMessage
        } catch {
            errorText = "Unexpected error: \(error.localizedDescription)"
        }
    }

    func saveLocation(location: CLLocationCoordinate2D, modelContext: ModelContext) {
        Task {
            do {
                let model = try await fetchTodayWeather(location: location, modelContext: modelContext, isCurrent: false)
                insertModels([model], modelContext: modelContext)
            } catch let weatherError as WeatherClientError {
                errorText = weatherError.errorMessage
            } catch {
                errorText = "Unexpected error: \(error.localizedDescription)"
            }
        }
    }

    func deleteLocation(for weatherModel: TodayWeatherUIModel, modelContext: ModelContext) {
        deleteModels([weatherModel], modelContext: modelContext)
    }

    private func insertModels<T: PersistentModel>(_ models: [T], modelContext: ModelContext) {
        DebugEnvironment.log.debug("\(LogMessages.insertingModels.rawValue)\(models)")
        models.forEach { modelContext.insert($0) }
        do {
            DebugEnvironment.log.debug(LogMessages.savingContext.rawValue)
            try modelContext.save()
        } catch {
            DebugEnvironment.log.debug("\(LogMessages.errorSavingContext.rawValue)\(error)")
            print(error)
        }
    }

    private func deleteModels<T: PersistentModel>(_ models: [T], modelContext: ModelContext) {
        DebugEnvironment.log.debug("\(LogMessages.deletingModels.rawValue)\(models)")
        models.forEach { modelContext.delete($0) }
        do {
            DebugEnvironment.log.debug(LogMessages.savingContext.rawValue)
            try modelContext.save()
        } catch {
            DebugEnvironment.log.debug("\(LogMessages.errorSavingContext.rawValue)\(error)")
        }
    }
}
