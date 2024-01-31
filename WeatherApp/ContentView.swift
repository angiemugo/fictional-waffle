//
//  ContentView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import SwiftUI

struct ContentView: View {
    private let client = WeatherClient()
    @StateObject var locationManager = LocationManager()
    @StateObject var weatherService = WeatherService(dataSource: RemoteDataSource(WeatherClient()))
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
                        Button {
                            favorite.toggle()
                        } label: {
                            Image(systemName: favorite ? "bookmark.fill" : "bookmark")
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
            .onReceive(locationManager.$lastLocation) { location in
                if let location = locationManager.lastLocation {
                    Task { await weatherService.onAppearAction(location) }
                }
            }
            .sheet(item: $weatherService.alertError) { error in
                Text(error.localizedDescription)
            }
    }
}

#Preview {
    ContentView()
}
