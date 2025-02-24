//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import SwiftUI
import SwiftData
import CoreLocation

struct WeatherDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var weatherForecast: [ForecastUIModel]
    @EnvironmentObject private var viewModel: WeatherViewModel
    var currentWeather: TodayWeatherUIModel

    var body: some View {
        VStack {
            ZStack {
                Image(BackgroundImage.create(rawValue: currentWeather.desc).background)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("\(currentWeather.min, specifier: "%.1f")°C")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Text(currentWeather.desc)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top, 50)
            }

            HStack {
                VStack {
                    Text("\(currentWeather.min, specifier: "%.1f")°C")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(AppStrings.min.rawValue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack {
                    Text("\(currentWeather.current, specifier: "%.1f")°C")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(AppStrings.current.rawValue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                VStack {
                    Text("\(currentWeather.max, specifier: "%.1f")°C")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text(AppStrings.max.rawValue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.horizontal)

            Divider()
                .frame(height: 1)
                .background(Color.white)

            ForEach(groupModel().sorted(by: {
                guard let firstValue1 = $0.value.first, let firstValue2 = $1.value.first else {
                    return false
                }
                return firstValue1.dtTxt < firstValue2.dtTxt
            }), id: \.key) { model in
                if let first = model.value.first {
                    HStack {
                        Text(model.key)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        WeatherIcons.create(rawValue: first.weather).icon
                        Text("\(first.temp, specifier: "%.1f")°C")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .task {
            let location = CLLocationCoordinate2D(latitude: currentWeather.location.latitude,
                                                  longitude: currentWeather.location.longitude)
            await viewModel.fetchWeatherForecast(location: location, modelContext: modelContext)
        }
        .background(WeatherColor.create(rawValue: currentWeather.desc).color)
        .navigationTitle(currentWeather.location.name)
    }

    private func groupModel() -> [String: [ForecastUIModel]] {
        Dictionary(grouping: weatherForecast, by: { $0.dayOfWeek })
    }
}

#Preview {
    let day = TodayWeatherUIModel(id: 1740365084,
                                  desc: "cloud",
                                  min: 10,
                                  current: 20,
                                  max: 30,
                                  latitude: 5,
                                  longitude: 10,
                                  isCurrentLocation: true,
                                  locationName: "Nairobi")
    WeatherDetailView(currentWeather: day)
        .environmentObject(WeatherViewModel(dataSource:
                                                RemoteDataSource(client: WeatherClient())))
        .modelContainer(for: ForecastUIModel.self,
                        inMemory: true)
}
