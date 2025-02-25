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
    @ObservedObject var locationService = LocationService.shared

    init(savedLocations: Binding<[TodayWeatherUIModel]>,
         presented: Binding<Bool>) {
        _savedLocations = savedLocations
        _presented = presented
    }

    var body: some View {
      let region = MKCoordinateRegion(
            center: locationService.lastLocation?.coordinate
            ?? CLLocationCoordinate2D(latitude: -1.286389,
                                      longitude: 36.817223),
            span: MKCoordinateSpan(latitudeDelta: 1,
                                   longitudeDelta: 1)
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
