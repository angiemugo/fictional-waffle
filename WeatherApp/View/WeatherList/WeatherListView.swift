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
    @Query private var savedLocationsQuery: [TodayWeatherUIModel]

    @State private var showMap = false
    @State private var firstLaunch = true
    @State private var hasFetchedOnce = false
    @ObservedObject private var locationService = LocationService.shared

    var body: some View {
        List {
            if case .Loading = viewModel.status { loadingView }
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
        .task { fetchWeatherOnce() }
        .refreshable { refresh() }
        .onReceive(locationService.$locationStatus.combineLatest(locationService.$lastLocation)) { handleLocationChange($0, $1) }
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
            if let currentLocation = savedLocationsQuery.first(where: { $0.isCurrentLocation }) {
                locationRow(currentLocation)
            } else {
                Text(locationService.locationStatus == .denied ?
                     ErrorMessages.locationAccessDenied.rawValue
                     : AppStrings.fetchingLocation.rawValue)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var savedLocationsSection: some View {
        let filteredLocations = savedLocationsQuery.filter { !$0.isCurrentLocation }

        return Section(AppStrings.savedLocations.rawValue) {
            if filteredLocations.isEmpty {
                ContentUnavailableView(AppStrings.noSavedLocations.rawValue,
                                       systemImage: AppStrings.trayIcon.rawValue)
            } else {
                ForEach(filteredLocations) { locationRow($0) }
            }
        }
    }

    private var addButton: some View {
        Button(action: { showMap.toggle() }) {
            Image(systemName: AppStrings.plusIcon.rawValue)
        }
    }

    private var mapSheet: some View {
        FavoriteMapView(savedLocations: .constant(savedLocationsQuery),
                        presented: $showMap)
            .environmentObject(viewModel)
    }

    @ViewBuilder
    private func locationRow(_ weather: TodayWeatherUIModel) -> some View {
        let location = weather.location
        let latitude = location.latitude
        let longitude = location.longitude
        let forecast = Query(filter: #Predicate<ForecastUIModel> {
            $0.latitude == latitude && $0.longitude == longitude
        })
        NavigationLink(destination: WeatherDetailView(_weatherForecast: forecast,
                                                      currentWeather: weather)
            .environmentObject(viewModel)) {
            FavouriteView(currentWeather: weather)
        }
        .swipeActions(edge: .trailing) { deleteButton(for: weather) }
    }

    private func deleteButton(for weather: TodayWeatherUIModel) -> some View {
        Button(role: .destructive, action: { deleteFave(weather) }) {
            Label(AppStrings.delete.rawValue,
                  systemImage: AppStrings.trashIcon.rawValue)
        }
        .tint(.red)
    }

    // MARK: - Actions

    private func fetchWeatherOnce() {
        guard !hasFetchedOnce else { return }
        hasFetchedOnce = true
        refresh()
    }

    private func refresh() {
        Task {
            guard !savedLocationsQuery.isEmpty else { return }
            await viewModel.fetchSavedLocationsWeather(for: savedLocationsQuery
                .map { $0.location.coordinate.coordinate },
                                                       modelContext: modelContext)
        }
    }

    private func handleLocationChange(_ status: CLAuthorizationStatus?, _ location: CLLocation?) {
        guard let location = location, let status = status, firstLaunch else { return }
        firstLaunch = false
        handleLocationUpdate(for: status,
                             location: location)
    }

    private func handleLocationUpdate(for status: CLAuthorizationStatus, location: CLLocation) {
        Task { await viewModel.fetchCurrentWeather(for: location,
                                                   locationStatus: status,
                                                   modelContext: modelContext) }
    }

    private func deleteFave(_ weather: TodayWeatherUIModel) {
        viewModel.deleteLocation(for: weather,
                                 modelContext: modelContext)
    }
}
