//
//  ContentView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import SwiftUI

struct ContentView: View {
    private let client = WeatherClient()
    @StateObject var weatherService = WeatherService(locationManager: LocationManager(), client: WeatherClient())

    var body: some View {
        VStack {
            Image("sea_sunny", bundle: nil).resizable().aspectRatio(contentMode: .fit)
            HStack {
                VStack {
                    Text((todayWeather?.main.tempMin ?? 0).toString()).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Text("Min")
                }
                VStack {
                    Text((todayWeather?.main.temp ?? 0).toString()).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Text("Current")
                }
                VStack {
                    Text((todayWeather?.main.tempMax ?? 0).toString()).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Text("Max")
                }
            }.padding(.horizontal)
                        Divider().background(Color.white).frame(height: 4)
            ForEach(grouped.sorted(by: { $0.key > $1.key }), id: \.key) { model in
                            HStack {
                                Text(model.key).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                Text(model.value.first?.weather.first?.main ?? "").frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                                Text("\(model.value.first!.main.temp)").frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                            }.padding(.horizontal)
                        }
                        Spacer()
                    }.background(Color.blue)
            .navigationTitle(todayWeather?.name ?? "")
        .task {
            do {
                try weatherService.fetchTodayWeather()
                try weatherService.fetchTodayWeather()
            } catch {
                print("This is the error: \(error)")
            }
        }

    }
}

//#Preview {
//    ContentView()
//}
