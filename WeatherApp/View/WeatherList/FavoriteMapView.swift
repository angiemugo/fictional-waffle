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
    @Binding var savedLocations: [TodayWeatherUIModel]
    @Binding var presented: Bool
    @StateObject var locationService = LocationService.shared

    init(savedLocations: Binding<[TodayWeatherUIModel]>, presented: Binding<Bool>) {
        _savedLocations = savedLocations
        _presented = presented
    }

    var body: some View {
      let region = MKCoordinateRegion(
            center: locationService.lastLocation?.coordinate ?? CLLocationCoordinate2D(),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )

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
    }

    func saveModel(_ location: CLLocationCoordinate2D) {
        viewModel.saveLocation(location: location, modelContext: modelContext)
    }
}

#Preview {
    let day = TodayWeatherUIModel(id: 1740365084,
                                  desc: "cloud",
                                  min: 10,
                                  current: 20,
                                  max: 30,
                                  latitude: 5,
                                  longitude: 10,
                                  isCurrentLocation: true,
                                  locationName: "Nairobi")
    FavoriteMapView(savedLocations: .constant([day]),
                    presented: .constant(true))
    .environmentObject(WeatherViewModel(dataSource: RemoteDataSource(client: WeatherClient())))
}
