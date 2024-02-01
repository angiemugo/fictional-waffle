//
//  FavoriteListView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import SwiftUI
import CoreLocation
import SwiftData
extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct FavoriteListView: View {
    @Query var savedLocations: [TodayWeatherUIModel]
    @Environment(\.modelContext) var modelContext
    @StateObject var locationManager = LocationManager.shared
    @State var currentLocation: TodayWeatherUIModel?
    @StateObject var faveVM: FavoriteViewModel
    @State private var searchText = ""
    @State private var showMap = false
    @State private var newLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    var body: some View {
        List {
            if let current = currentLocation {
                Section("My Location") {
                    NavigationLink {
                        WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())),
                                          todayModel: current)
                    } label: {
                        FavouriteView(location: current)
                    }
                }
            }

            ForEach(filteredLocations) { location in
                Section("Saved Locations") {
                    NavigationLink {
                        WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())),
                                          todayModel: location)
                    } label: {
                        FavouriteView(location: location)
                    }
                }
            }
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a location")
            .toolbar {
                Button {
                    addLocation()
                } label: {
                    Image(systemName: "plus")
                }
            }.onChange(of: locationManager.lastLocation.coordinate) { oldValue, newValue in
                Task {
                    let new = try? await faveVM.fetchCurrentLocation(newValue.latitude, newValue.longitude)
                    currentLocation = new
                }
            }.onReceive(faveVM.$fetchedLocations) { newLocations in
                for newLocation in newLocations {
                    modelContext.delete(newLocation)
                    modelContext.insert(newLocation)
                }
            }.sheet(isPresented: $showMap) {
                FavoriteMapView(savedLocations: savedLocations, current: currentLocation, presented: $showMap, newLocation: $newLocation)
            }.onChange(of: newLocation) { oldValue, newValue in
                Task {
                    let new = try! await faveVM.fetchCurrentLocation(newValue.latitude, newValue.longitude)
                    modelContext.insert(new)
                }
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
