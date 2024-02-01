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

    var body: some View {
        Map {
            if let current = current {
                Marker("\(current.locationName), \(current.current)", systemImage: "person", coordinate: CLLocationCoordinate2D(latitude: current.lat, longitude: current.lon))

        }
            ForEach(savedLocations) { location in
                Marker(coordinate:  CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)) {
                    Text("\(location.locationName), Temp: \(location.current)")
                }
            }
        }
    }
}
