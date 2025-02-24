//
//  PreviewSampleData.swift
//  WeatherApp
//
//  Created by Angie Mugo on 24/02/2025.
//

import SwiftData
import CoreLocation

actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        return try! inMemoryContainer()
    }()

    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([TodayWeatherUIModel.self, ForecastUIModel.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])

        let sampleTodayWeather: [TodayWeatherUIModel] = [
            .sample1, .sample2, .sample3, .sample4
        ]

        let sampleForecasts: [ForecastUIModel] = [
            .sample1, .sample2, .sample3, .sample4, .sample5
        ]

        Task { @MainActor in
            sampleTodayWeather.forEach { container.mainContext.insert($0) }
            sampleForecasts.forEach { container.mainContext.insert($0) }
        }

        return container
    }
}

// MARK: - Sample Data
extension TodayWeatherUIModel {
    static var sample1: TodayWeatherUIModel {
        .init(id: 1, desc: "Sunny", min: 20.0, current: 25.0, max: 30.0, latitude: 37.7749, longitude: -122.4194, isCurrentLocation: true, locationName: "San Francisco, USA")
    }

    static var sample2: TodayWeatherUIModel {
        .init(id: 2, desc: "Cloudy", min: 18.0, current: 22.0, max: 28.0, latitude: 51.5074, longitude: -0.1278, isCurrentLocation: false, locationName: "London, UK")
    }

    static var sample3: TodayWeatherUIModel {
        .init(id: 3, desc: "Rainy", min: 15.0, current: 18.0, max: 23.0, latitude: 48.8566, longitude: 2.3522, isCurrentLocation: false, locationName: "Paris, France")
    }

    static var sample4: TodayWeatherUIModel {
        .init(id: 4, desc: "Snowy", min: -5.0, current: 0.0, max: 5.0, latitude: 40.7128, longitude: -74.0060, isCurrentLocation: false, locationName: "New York, USA")
    }
}

extension ForecastUIModel {
    static var sample1: ForecastUIModel {
        .init(weather: "Sunny", dayOfWeek: "Monday", temp: 28.0, dtTxt: Date(), location: Coordinates(lat: 37.7749, lon: -122.4194))
    }

    static var sample2: ForecastUIModel {
        .init(weather: "Cloudy", dayOfWeek: "Tuesday", temp: 22.0, dtTxt: Date().addingTimeInterval(86400), location: Coordinates(lat: 51.5074, lon: -0.1278))
    }

    static var sample3: ForecastUIModel {
        .init(weather: "Rainy", dayOfWeek: "Wednesday", temp: 19.0, dtTxt: Date().addingTimeInterval(2 * 86400), location: Coordinates(lat: 48.8566, lon: 2.3522))
    }

    static var sample4: ForecastUIModel {
        .init(weather: "Snowy", dayOfWeek: "Thursday", temp: -2.0, dtTxt: Date().addingTimeInterval(3 * 86400), location: Coordinates(lat: 40.7128, lon: -74.0060))
    }

    static var sample5: ForecastUIModel {
        .init(weather: "Windy", dayOfWeek: "Friday", temp: 15.0, dtTxt: Date().addingTimeInterval(4 * 86400), location: Coordinates(lat: 35.6895, lon: 139.6917))
    }
}
