//
//  ContentView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import SwiftUI

enum Theme: String, CaseIterable {
    case forest
    case sea
}

struct ContentView: View {
    private let client = WeatherClient()
    @StateObject var weatherService = WeatherService(locationManager: LocationManager(), client: WeatherClient())
    @AppStorage("theme") private var theme: Theme?
    @State private var favorite = false

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                weatherService.weatherToday?.backgroundImage
                    .resizable().aspectRatio(contentMode: .fit)
                HStack {
                    Text(weatherService.weatherToday?.locationName ?? "")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                        .padding()
                    VStack {
                        Button {
                            favorite.toggle()
                        } label: {
                            Image(systemName: favorite ? "bookmark.fill" : "bookmark")
                        }

                        Picker("Settings", systemImage: "gear", selection: $theme) {
                            ForEach(Theme.allCases, id: \.self) {
                                Text("\($0.rawValue.uppercased()) Theme").foregroundStyle(.black)
                            }
                        }
                    }
                }
            }
            HStack {
                VStack {
                    Text(weatherService.weatherToday?.min ?? "")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Text("Min")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                }

                VStack {
                    Text(weatherService.weatherToday?.current ?? "")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)

                    Text("Current")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                }

                VStack {
                    Text(weatherService.weatherToday?.max ?? "")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                    Text("Max")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                }
            }.padding(.horizontal)
            Divider()
                .frame(height: 1)
                .background(Color.white)
            List {
                ForEach(weatherService.groupedModel.sorted(by: { $0.value.first!.dtTxt < $1.value.first!.dtTxt }), id: \.key) { model in
                    HStack {
                        Text(model.key)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        model.value.first?.weather
                        Text(model.value.first?.temp ?? "")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                    }
                }
            }.listStyle(.plain)
        }.background(Color.blue)
            .task {
                do {
                    try await weatherService.fetchTodayWeather()
                    try await weatherService.fetchWeatherForecast()
                } catch {
                    print("This is the error: \(error)")
                }
            }
    }
}

//#Preview {
//    ContentView()
//}
