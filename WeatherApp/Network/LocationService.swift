//
//  LocationService.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation, Error>?

    static let shared = LocationService()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        checkAuthorization()
    }

    var currentLocation: CLLocation {
        get async throws {
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                locationManager.requestLocation()
            }
        }
    }

    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DebugEnvironment.log.debug(LogMessages.didUpdateLocations.rawValue)
        guard let location = locations.last else { return }
        continuation?.resume(returning: location)
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DebugEnvironment.log.debug("\(LogMessages.updatingLocationsFailed.rawValue)\(error)")
        continuation?.resume(throwing: WeatherClientError.locationError(message:
                                                                            ErrorMessages.locationAccessDenied.rawValue))
        continuation = nil
    }
}
