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

    var body: some View {
        List {
            Section(AppStrings.myLocation.rawValue) {
                if let currentLocation = savedLocationsQuery.first {
                    locationRow(currentLocation)
                } else {
                    Text(AppStrings.fetchingLocation.rawValue)
                        .foregroundStyle(.secondary)
                }
            }

            Section(AppStrings.savedLocations.rawValue) {
                if savedLocationsQuery.count <= 1 {
                    ContentUnavailableView(AppStrings.noSavedLocations.rawValue,
                                           systemImage: AppStrings.trayIcon.rawValue)
                } else {
                    savedLocationsView
                }
            }
        }
        .listRowSpacing(10)
        .toolbar {
            Button {
                addLocation()
            } label: {
                Image(systemName: AppStrings.plusIcon.rawValue)
            }
        }
        .sheet(isPresented: $showMap) {
            FavoriteMapView(savedLocations: .constant(savedLocationsQuery),
                            presented: $showMap)
            .environmentObject(viewModel)
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(AppStrings.errorTitle.rawValue),
                message: Text(viewModel.errorText ?? AppStrings.genericError.rawValue),
                dismissButton: .default(Text(AppStrings.okButton.rawValue))
            )
        }
        .alert(isPresented: $viewModel.showAlert) {
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
        .task {
            await viewModel.getCurrentLocation()
            guard let currentLocation = viewModel.currentLocation else { return }
            await viewModel.fetchCurrentWeather(location: currentLocation,
                modelContext: modelContext)
            refresh()
        }
        .refreshable {
            refresh()
        }
    }

    func refresh() {
        Task {
            let locations = savedLocations.map { $0.location.coordinate }
            await viewModel.fetchSavedLocationsWeather(for: locations,
                                                       modelContext: modelContext)
        }
    }

    @ViewBuilder
    private var savedLocationsView: some View {
        ForEach(savedLocationsQuery[1...]) { location in
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
            }.tint(Color(.systemRed))
        }
    }

    private func addLocation() {
        showMap.toggle()
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
