//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import SwiftUI
import SwiftData

@main
struct WeatherAppApp: App {
    let modelContainer = DataModel.shared.modelContainer
    @State var searchText: String = ""
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let viewModel = WeatherViewModel(dataSource: RemoteDataSource(client: WeatherClient()))
                WeatherListView(_savedLocationsQuery: savedLocationsQuery)
                    .environmentObject(viewModel)
                    .searchable(text: $searchText, prompt: "Search for a location")
            }.tint(.primary)
        }
        .modelContainer(modelContainer)
    }
    
    var savedLocationsQuery: Query<TodayWeatherUIModel, [TodayWeatherUIModel]> {
        var predicate: Predicate<TodayWeatherUIModel>?
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            predicate = .init( #Predicate{ $0.locationName.contains(searchText) })
        }

        return Query(filter: predicate,
                     sort: \TodayWeatherUIModel.isCurrentLocation,
                     order: .reverse)
    }
}
