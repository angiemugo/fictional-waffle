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
    var savedLocations: [TodayWeatherUIModel]
    @Binding var presented: Bool
    @ObservedObject var faveVM: FavoriteViewModel
    @State private var errorString: String = ""

    var body: some View {
        let currentCoordinates = CLLocationCoordinate2D(latitude: faveVM.currentLocation?.lat ?? 0, longitude: faveVM.currentLocation?.lon ?? 0)
        let span =  MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: currentCoordinates, span: span)
        let initialPosition = MapCameraPosition.region(region)
        NavigationView {
            MapReader { proxy in
                Map(initialPosition: initialPosition) {
                    if let current = faveVM.currentLocation {
                        Marker("\(current.locationName), \(current.current)", systemImage: "person", coordinate: currentCoordinates)

                    }
                    ForEach(savedLocations) { location in
                        Marker(coordinate:  CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)) {
                            Text("\(location.locationName), Temp: \(location.current)")
                        }
                    }
                }.onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        saveModel(coordinate)
                        presented = false
                    }
                }
            }
        }.tint(.primary)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presented.toggle()
                    } label: {
                        Image(systemName: "x.square")
                    }
                }
            }
    }

    func saveModel(_ location: CLLocationCoordinate2D) {
        Task {
            await faveVM.fetchForSaved(location.latitude, location.longitude)
        }
    }
}
