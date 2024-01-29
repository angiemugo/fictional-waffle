//
//  ContentView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import SwiftUI
struct ForecastModel {
    var day: String
    var weather: String
    var temperature: String
}

struct TodayWeatherModel {
    var minTemp: Int
    var currentTemp: Int
    var maxTemp: Int
}

struct ContentView: View {
    var body: some View {
        VStack{
            Image("sea_sunny", bundle: nil).resizable().aspectRatio(contentMode: .fit)
            HStack {
                    Text("19").frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Text("25").frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                    Text("27").frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
            }.padding(.horizontal)
            Divider().background(Color.white).frame(height: 4)
            ForEach(models, id: \.day) { model in
                HStack {
                        Text(model.day).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        Text(model.weather).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                        Text(model.temp).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                }.padding(.horizontal)
            }
            Spacer()
        }.background(Color.blue)

    }
}

#Preview {
    ContentView()
}
