//
//  DataModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 21/02/2025.
//

import SwiftData

actor DataModel {
    static let shared = DataModel()

    private init() {}

    nonisolated lazy var modelContainer: ModelContainer = {
        let modelContainer: ModelContainer
        do {
            DebugEnvironment.log.debug("Initialising swift data model")
            modelContainer = try ModelContainer(for: TodayWeatherUIModel.self, ForecastUIModel.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
}
