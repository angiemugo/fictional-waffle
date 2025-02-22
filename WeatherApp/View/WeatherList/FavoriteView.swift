//
//  FavoriteView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 01/02/2024.
//

import SwiftUI

struct FavouriteView: View {
    var currentWeather: TodayWeatherUIModel

    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(currentWeather.location.name)
                        .font(.headline)
                    Spacer()
                    Text(currentWeather.desc)
                }

                Spacer()

                VStack {
                    Text(String(format: AppStrings.currentTemperature.rawValue, currentWeather.current))
                    Spacer()
                    Text(String(format: AppStrings.highTemperature.rawValue, currentWeather.max))
                    Text(String(format: AppStrings.lowTemperature.rawValue, currentWeather.min))
                }
            }
        }
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
    FavouriteView(currentWeather: day)
}
