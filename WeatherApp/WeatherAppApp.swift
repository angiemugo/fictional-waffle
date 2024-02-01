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
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FavoriteListView(faveVM: FavoriteViewModel(dataSource: RemoteDataSource(WeatherClient())))
            }
        }.modelContainer(for: TodayWeatherUIModel.self)
    }
}
