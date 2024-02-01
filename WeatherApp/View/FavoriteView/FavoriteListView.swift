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
                if let currentLocation = faveVM.currentLocation {
                    NavigationLink {
                        WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())),
                                          todayModel: currentLocation, isFave: false)
                    } label: {
                        FavouriteView(location: currentLocation)
                    }
                } else {
                    Text("We are having a problem accessing your location! Make sure your location services are turned on.")
                }
            }

            Section("Saved Locations") {
                ForEach(filteredLocations) { location in
                    NavigationLink {
                        WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())),
                                          todayModel: location, isFave: true)
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
                }.tint(.primary)
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
                FavoriteMapView(savedLocations: savedLocations, presented: $showMap, faveVM: faveVM)
            }.alert(isPresented: $faveVM.showAlert) {
                Alert(
                    title: Text("Error Fetching"),
                    message: Text(faveVM.errorString),
                    dismissButton: .default(Text("OK"))
                )
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodayWeatherUIModel.self, configurations: config)

    return FavoriteListView(faveVM: FavoriteViewModel(dataSource: RemoteDataSource(WeatherClient())))
}
