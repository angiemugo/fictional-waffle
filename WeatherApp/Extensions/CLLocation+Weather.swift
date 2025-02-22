//
//  CLLocation+Weather.swift
//  WeatherApp
//
//  Created by Angie Mugo on 01/02/2024.
//

import CoreLocation

extension CLLocation: @retroactive Comparable {
    public static func < (lhs: CLLocation, rhs: CLLocation) -> Bool {
        if lhs.coordinate.latitude != rhs.coordinate.latitude {
            return lhs.coordinate.latitude < rhs.coordinate.latitude
        }
        return lhs.coordinate.longitude < rhs.coordinate.longitude
    }
}
