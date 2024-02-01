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
    var current: TodayWeatherUIModel?
    @Environment(\.modelContext) var modelContext
    @Binding var presented: Bool
    @Binding var newLocation: CLLocationCoordinate2D


    var body: some View {
        let currentCoordinates = CLLocationCoordinate2D(latitude: current?.lat ?? 0, longitude: current?.lon ?? 0)
        let span =  MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: currentCoordinates, span: span)
        let initialPosition = MapCameraPosition.region(region)
        NavigationView {
            MapReader { proxy in
                Map(initialPosition: initialPosition) {
                    if let current = current {
                        Marker("\(current.locationName), \(current.current)", systemImage: "person", coordinate: currentCoordinates)

                    }
                    ForEach(savedLocations) { location in
                        Marker(coordinate:  CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)) {
                            Text("\(location.locationName), Temp: \(location.current)")
                        }
                    }
                }.onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        newLocation = coordinate
                        presented = false
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presented.toggle()
                } label: {
                    Image(systemName: "x.square")
                }
            }
        }
    }
}
