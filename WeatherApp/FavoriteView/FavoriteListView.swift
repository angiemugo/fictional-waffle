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
    @State private var searchText = ""
    @State private var showMap = false
    @Query var savedLocations: [TodayWeatherUIModel]
    @Environment(\.modelContext) var modelContext
    @StateObject var locationManager = LocationManager.shared
    @ObservedObject var faveVM: FavoriteViewModel

    var body: some View {
        List {
            Section("My Location") {
                if let _ = locationManager.lastLocation, let current = filteredLocations.first {
                    NavigationLink {
                        WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())),
                                          todayModel: current)
                    } label: {
                        FavouriteView(location: current)
                    }
                } else {
                    Text("We are having a problem accessing your location! Make sure your location services are turned on.")
                }
            }

            Section("Saved Locations") {
                ForEach(filteredLocations) { location in
                        NavigationLink {
                            WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())),
                                              todayModel: location)
                        } label: {
                            FavouriteView(location: location)
                        }
                    }
            }
        }.listRowSpacing(10)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a location")
            .toolbar {
                Button {
                    addLocation()
                } label: {
                    Image(systemName: "plus")
                }.tint(.white)
            }.onReceive(locationManager.$lastLocation) { value in
                Task {
                    guard let lat = value?.coordinate.latitude, let lon = value?.coordinate.longitude else { return }
                    await faveVM.fetchCurrentLocation(lat, lon)
                }
            }.onChange(of: faveVM.fetchedLocations) { oldValue, newValue in
                for newLocation in newValue {
                    modelContext.insert(newLocation)
                }
            }
            .sheet(isPresented: $showMap) {
                FavoriteMapView(savedLocations: savedLocations, current: faveVM.fetchedLocations.first, presented: $showMap, faveVM: faveVM)
            }
    }


    private var filteredLocations: [TodayWeatherUIModel] {
        if searchText.isEmpty {
            return faveVM.fetchedLocations
        } else {
            return faveVM.fetchedLocations.filter { $0.locationName.contains(searchText) }
        }
    }

    func addLocation() {
        showMap.toggle()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodayWeatherUIModel.self, configurations: config)
    let day = TodayWeatherUIModel(locationName: "Nairobi", desc: "cloud", min: "10", current: "20", max: "30", lat: 5, lon: 10, isFavorite: false)

    return FavoriteListView(faveVM: FavoriteViewModel(dataSource: RemoteDataSource(WeatherClient())))
}
