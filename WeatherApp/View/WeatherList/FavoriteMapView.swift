//
//  FavoriteMapView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 31/01/2024.
//

import SwiftUI
import CoreLocation
import MapKit

struct FavoriteMapView: View {
    @EnvironmentObject private var viewModel: WeatherViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var errorString: String = ""
    @State private var currentLocation: CLLocationCoordinate2D?
    @State private var region: MKCoordinateRegion
    @Binding var savedLocations: [TodayWeatherUIModel]
    @Binding var presented: Bool

    init(savedLocations: Binding<[TodayWeatherUIModel]>, presented: Binding<Bool>) {
        _savedLocations = savedLocations
        _presented = presented

        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -1.286389, longitude: 36.817223),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        NavigationView {
            MapReader { proxy in
                Map(initialPosition: .region(region)) {
                    if let currentLocation = currentLocation {
                        Marker(AppStrings.myLocation.rawValue,
                               systemImage: AppStrings.personIcon.rawValue,
                               coordinate: currentLocation)
                    }
                    ForEach(savedLocations) { location in
                        Marker(location.locationName,
                               coordinate: location.location.coordinate.coordinate)
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position,
                                                      from: .local) {
                        saveModel(coordinate)
                        presented = false
                    }
                }
            }
        }
        .tint(.primary)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presented.toggle()
                } label: {
                    Image(systemName: AppStrings.closeIcon.rawValue)
                }
            }
        }
        .task {
            await fetchCurrentLocation()
        }
    }

    private func fetchCurrentLocation() async {
//        guard let location = viewModel.currentLocation else { return }
//        currentLocation = location.coordinate
    }

    func saveModel(_ location: CLLocationCoordinate2D) {
        viewModel.saveLocation(location: location, modelContext: modelContext)
    }
}

#Preview {
    let day = TodayWeatherUIModel(locationName: "Nairobi",
                                  desc: "cloud",
                                  min: 10,
                                  current: 20,
                                  max: 30,
                                  latitude: 5,
                                  longitude: 10,
                                  isCurrentLocation: true)
    FavoriteMapView(savedLocations: .constant([day]),
                    presented: .constant(true))
    .environmentObject(WeatherViewModel(dataSource: RemoteDataSource(client: WeatherClient())))
}
