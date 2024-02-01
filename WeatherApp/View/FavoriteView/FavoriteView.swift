//
//  FavoriteView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 01/02/2024.
//

import SwiftUI

struct FavouriteView: View {
    @State var location: TodayWeatherUIModel

    var body: some View {
        Group {
            HStack {
                VStack {
                    Text(location.locationName).font(.headline)
                    Spacer()
                    Text(location.desc)
                }
                Spacer()

                VStack {
                    Text(location.current).font(.largeTitle)
                    Spacer()
                    Text("H: \(location.max), L: \(location.min)")
                }
            }
        }.background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))

    }
}

#Preview {
    let day = TodayWeatherUIModel(locationName: "Nairobi", desc: "cloud", min: "10", current: "20", max: "30", lat: 5, lon: 10)
    return FavouriteView(location: day)
}
