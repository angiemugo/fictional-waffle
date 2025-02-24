//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import SwiftUI
import SwiftData

@main
struct WeatherApp: App {
    let modelContainer = DataModel.shared.modelContainer
    @State var searchText: String = ""
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let viewModel = WeatherViewModel(dataSource: RemoteDataSource(client: WeatherClient()))
                WeatherListView(_savedLocationsQuery: savedLocationsQuery)
                    .environmentObject(viewModel)
            }.tint(.primary)
        }
        .modelContainer(modelContainer)
    }
    
    var savedLocationsQuery: Query<TodayWeatherUIModel, [TodayWeatherUIModel]> {
        return Query(sort: \TodayWeatherUIModel.isCurrentLocation,
                     order: .reverse)
    }
}
