//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import SwiftUI
import CoreLocation
import SwiftData

struct WeatherListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var viewModel: WeatherViewModel
    @Query var savedLocationsQuery: [TodayWeatherUIModel]

    @State private var showMap = false
    @State private var firstLaunch = true
    @State private var savedLocations: [TodayWeatherUIModel] = []
    @ObservedObject private var locationService = LocationService.shared

    var body: some View {
        List {
            if case .Loading = viewModel.status {
                loadingView
            }
            myLocationSection
            savedLocationsSection
        }
        .listRowSpacing(10)
        .toolbar { addButton }
        .sheet(isPresented: $showMap) { mapSheet }
        .snackbar(
            show: $viewModel.showAlert,
            bgColor: viewModel.isError ? .red : .green,
            message: viewModel.statusText ?? ""
        )
        .task { refresh() }
        .refreshable { refresh() }
        .onReceive(
            locationService.$locationStatus
                .combineLatest(locationService.$lastLocation)
        ) { status, location in
            guard let location = location, firstLaunch else {
                return
            }
            firstLaunch = false

            Task {
                await viewModel.fetchCurrentWeather(
                    for: location,
                    locationStatus: status,
                    modelContext: modelContext
                )
            }
        }
    }

    // MARK: - UI Components

    private var loadingView: some View {
        Section {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
    }

    private var myLocationSection: some View {
        Section(AppStrings.myLocation.rawValue) {
            if let currentLocation = savedLocationsQuery.first {
                locationRow(currentLocation)
            } else {
                Text(AppStrings.fetchingLocation.rawValue)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var savedLocationsSection: some View {
        Section(AppStrings.savedLocations.rawValue) {
            if savedLocationsQuery.count <= 1 {
                ContentUnavailableView(
                    AppStrings.noSavedLocations.rawValue,
                    systemImage: AppStrings.trayIcon.rawValue
                )
            } else {
                savedLocationsView
            }
        }
    }

    private var addButton: some View {
        Button { showMap.toggle() } label: {
            Image(systemName: AppStrings.plusIcon.rawValue)
        }
    }

    private var mapSheet: some View {
        FavoriteMapView(
            savedLocations: .constant(savedLocationsQuery),
            presented: $showMap
        )
        .environmentObject(viewModel)
    }

    @ViewBuilder
    private var savedLocationsView: some View {
        ForEach(savedLocationsQuery.dropFirst()) { location in
            locationRow(location)
        }
    }

    @ViewBuilder
    private func locationRow(_ weather: TodayWeatherUIModel) -> some View {
        let location = weather.location
        let latitude = location.latitude
        let longitude = location.longitude
        let forecast = Query(filter: #Predicate<ForecastUIModel> {
            $0.latitude == latitude && $0.longitude == longitude
        })

        NavigationLink {
            WeatherDetailView(
                _weatherForecast: forecast,
                currentWeather: weather
            )
            .environmentObject(viewModel)
        } label: {
            FavouriteView(currentWeather: weather)
        }
        .swipeActions(edge: .trailing) {
            deleteButton(for: weather)
        }
    }

    private func deleteButton(for weather: TodayWeatherUIModel) -> some View {
        Button(role: .destructive) {
            deleteFave(weatherLocation: weather)
        } label: {
            Label(AppStrings.delete.rawValue, systemImage: AppStrings.trashIcon.rawValue)
        }
        .tint(.red)
    }

    // MARK: - Actions

    private func refresh() {
        Task {
            guard savedLocations.count > 0 else { return }
            let locations = savedLocations.map { $0.location.coordinate.coordinate }
            await viewModel.fetchSavedLocationsWeather(for: locations, modelContext: modelContext)
        }
    }

    private func handleLocationUpdate(for status: CLAuthorizationStatus, location: CLLocation) {
        Task {
            await viewModel.fetchCurrentWeather(
                for: location,
                locationStatus: status,
                modelContext: modelContext
            )
        }
    }

    private func deleteFave(weatherLocation: TodayWeatherUIModel) {
        viewModel.deleteLocation(for: weatherLocation, modelContext: modelContext)
    }
}
