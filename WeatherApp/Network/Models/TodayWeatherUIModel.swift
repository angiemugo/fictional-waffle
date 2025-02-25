//
//  TodayWeatherUIModel.swift
//  WeatherApp
//
//  Created by Angie Mugo on 30/01/2024.
//

import SwiftUI
import CoreLocation
import SwiftData

@Model
final class TodayWeatherUIModel {
    @Attribute(.unique) var id: Double
    var desc: String
    var min: Double
    var current: Double
    var max: Double
    var location: Location
    var isCurrentLocation: Bool = false
    var locationName: String

    init(id: Double,
         desc: String,
         min: Double,
         current: Double,
         max: Double,
         latitude: Double,
         longitude: Double,
         isCurrentLocation: Bool,
         locationName: String) {
        self.id = id
        self.desc = desc
        self.min = min
        self.current = current
        self.max = max
        self.locationName = locationName
        self.location = Location(name: locationName,
                                 longitude: longitude,
                                 latitude: latitude)
        self.isCurrentLocation = isCurrentLocation
    }

    convenience init(from fetchedWeather: TodayWeatherModel,
                     isCurrentLocation: Bool) {
        let locationName = fetchedWeather.sys.country.map
        { "\(fetchedWeather.name), \($0)" } ?? fetchedWeather.name

        self.init(id: fetchedWeather.id,
                  desc: fetchedWeather.weather.first?.main ?? "",
                  min: fetchedWeather.main.tempMin,
                  current: fetchedWeather.main.temp,
                  max: fetchedWeather.main.tempMax,
                  latitude: fetchedWeather.coord.lat,
                  longitude: fetchedWeather.coord.lon,
                  isCurrentLocation: isCurrentLocation,
                  locationName: locationName
        )
    }
}

struct Location: Codable, Equatable {
    var name: String
    var longitude: Double
    var latitude: Double

    var coordinate: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
