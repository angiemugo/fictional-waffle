//
//  FavoriteListView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import SwiftUI
import CoreLocation
import SwiftData

struct FavoriteListView: View {
    @Query var savedLocations: [TodayWeatherUIModel]
    @Environment(\.modelContext) var modelContext
    @StateObject var locationManager = LocationManager.shared
    @State var currentLocation: TodayWeatherUIModel?
    @StateObject var faveVM: FavoriteViewModel
    @State private var searchText = ""
    @State private var showMap = false

    var body: some View {
        List {
            if let current = currentLocation {
                NavigationLink {
                    WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())),
                                      todayModel: current)
                } label: {
                    FavouriteView(location: current)
                }
            }

            ForEach(filteredLocations) { location in
                NavigationLink {
                    WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())),
                                      todayModel: location)
                } label: {
                    FavouriteView(location: location)
                }
            }
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a location")
            .toolbar {
                Button {
                    addLocation()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .onReceive(locationManager.$lastLocation) { location in
                guard let lat = location?.coordinate.latitude, let
                        lon = location?.coordinate.longitude else {
                    return
                }
                Task {
                    let new = try? await faveVM.fetchCurrentLocation(lat, lon)
                    currentLocation = new
                }
            }.onReceive(faveVM.$fetchedLocations) { newLocations in
                for newLocation in newLocations {
                    modelContext.delete(newLocation)
                    modelContext.insert(newLocation)
                }
            }.sheet(isPresented: $showMap) {
                FavoriteMapView(savedLocations: savedLocations, current: currentLocation)
            }
    }

    private var filteredLocations: [TodayWeatherUIModel] {
        if searchText.isEmpty {
            return savedLocations
        } else {
            return savedLocations.filter { $0.locationName.contains(searchText) }
        }
    }

    func addLocation() {
        showMap.toggle()
    }
}

struct FavouriteView: View {
    @State var location: TodayWeatherUIModel

    var body: some View {
        VStack {
            HStack {
                Text(location.locationName)
                Text(location.current)
            }
            Spacer()
            Text("Min: \(location.min), Max: \(location.max)")
        }
    }
}
