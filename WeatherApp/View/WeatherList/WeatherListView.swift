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
    @State private var savedLocations: [TodayWeatherUIModel] = []
    @StateObject var locationService = LocationService.shared

    var body: some View {
        List {
            myLocationSection
            savedLocationsSection
        }
        .listRowSpacing(10)
        .toolbar { addButton }
        .sheet(isPresented: $showMap) { mapSheet }
        .alert(isPresented: $viewModel.showAlert, content: errorAlert)
        .task { refresh() }
        .refreshable { refresh() }
        .onReceive(locationService.$locationStatus) { handleLocationUpdate($0) }
    }

    // MARK: - UI Components

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
                ContentUnavailableView(AppStrings.noSavedLocations.rawValue,
                                       systemImage: AppStrings.trayIcon.rawValue)
            } else {
                savedLocationsView
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

    private func errorAlert() -> Alert {
        Alert(
            title: Text(AppStrings.errorTitle.rawValue),
            message: Text(viewModel.errorText ?? AppStrings.genericError.rawValue),
            primaryButton: .default(
                Text(ErrorMessages.tryAgain.rawValue),
                action: refresh
            ),
            secondaryButton: .cancel(Text(AppStrings.okButton.rawValue))
        )
    }

    @ViewBuilder
    private var savedLocationsView: some View {
        ForEach(savedLocationsQuery.dropFirst()) { location in
            locationRow(location)
        }
    }

    @ViewBuilder
    private func locationRow(_ weather: TodayWeatherUIModel) -> some View {
        NavigationLink {
            WeatherDetailView(currentWeather: weather)
                .environmentObject(viewModel)
        } label: {
            FavouriteView(currentWeather: weather)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                deleteFave(weather)
            } label: {
                Label(AppStrings.delete.rawValue, systemImage: AppStrings.trashIcon.rawValue)
            }.tint(.red)
        }
    }

    // MARK: - Actions

    private func refresh() {
        Task {
            let locations = savedLocations.map { $0.location.coordinate.coordinate }
            await viewModel.fetchSavedLocationsWeather(for: locations, modelContext: modelContext)
        }
    }

    private func handleLocationUpdate(_ status: CLAuthorizationStatus?) {
        Task {
            await viewModel.fetchCurrentWeather(for: locationService.lastLocation,
                                                locationStatus: status,
                                                modelContext: modelContext)
        }
    }

    private func deleteFave(_ weatherLocation: TodayWeatherUIModel) {
        viewModel.deleteLocation(for: weatherLocation, modelContext: modelContext)
    }
}

#Preview {
    WeatherListView()
        .environmentObject(WeatherViewModel(dataSource: RemoteDataSource(client: WeatherClient())))
        .modelContainer(for: TodayWeatherUIModel.self, inMemory: true)
}
