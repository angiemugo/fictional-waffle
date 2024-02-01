//
//  PreviewData.swift
//  WeatherApp
//
//  Created by Angie Mugo on 01/02/2024.
//

import Foundation

struct PreviewData {
    static let shared = PreviewData()
    
    private init() {
    }
    
    func getFavoriteUIModel() -> TodayWeatherUIModel {
        let data =
            """
{
            "coord": {
                "lon": 66.1185,
                "lat": 18.4671
            },
            "weather": [
                {
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01n"
                }
            ],
            "base": "stations",
            "main": {
                "temp": 23.53,
                "feels_like": 23.98,
                "temp_min": 23.53,
                "temp_max": 23.53,
                "pressure": 1016,
                "humidity": 78,
                "sea_level": 1016,
                "grnd_level": 1016
            },
            "visibility": 10000,
            "wind": {
                "speed": 2.75,
                "deg": 36,
                "gust": 3.18
            },
            "clouds": {
                "all": 5
            },
            "dt": 1706820549,
            "sys": {
                "sunrise": 1706839733,
                "sunset": 1706880557
            },
            "timezone": 14400,
            "id": 0,
            "name": "",
            "cod": 200
}
"""
        
        return try! JSONDecoder().decode(TodayWeatherModel.self, from: Data(data.utf8)).toUIModel()
    }
    
    func getForecastModel() -> [ForecastUIModel] {
        let data =
            """
{
    "cod": "200",
    "message": 0,
    "cnt": 40,
    "list": [
        {
            "dt": 1706821200,
            "main": {
                "temp": 23.53,
                "feels_like": 23.98,
                "temp_min": 23.53,
                "temp_max": 23.53,
                "pressure": 1016,
                "sea_level": 1016,
                "grnd_level": 1016,
                "humidity": 78,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01n"
                }
            ],
            "clouds": {
                "all": 5
            },
            "wind": {
                "speed": 2.75,
                "deg": 36,
                "gust": 3.18
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2024-02-01 21:00:00"
        },
        {
            "dt": 1706832000,
            "main": {
                "temp": 23.54,
                "feels_like": 23.96,
                "temp_min": 23.54,
                "temp_max": 23.57,
                "pressure": 1016,
                "sea_level": 1016,
                "grnd_level": 1015,
                "humidity": 77,
                "temp_kf": -0.03
            },
            "weather": [
                {
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01n"
                }
            ],
            "clouds": {
                "all": 9
            },
            "wind": {
                "speed": 3.17,
                "deg": 41,
                "gust": 3.56
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2024-02-02 00:00:00"
        },
        {
            "dt": 1706842800,
            "main": {
                "temp": 23.74,
                "feels_like": 24.13,
                "temp_min": 23.74,
                "temp_max": 23.85,
                "pressure": 1017,
                "sea_level": 1017,
                "grnd_level": 1017,
                "humidity": 75,
                "temp_kf": -0.11
            },
            "weather": [
                {
                    "id": 802,
                    "main": "Clouds",
                    "description": "scattered clouds",
                    "icon": "03d"
                }
            ],
            "clouds": {
                "all": 32
            },
            "wind": {
                "speed": 3.97,
                "deg": 48,
                "gust": 4.39
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2024-02-02 03:00:00"
        },
        {
            "dt": 1706853600,
            "main": {
                "temp": 24.25,
                "feels_like": 24.61,
                "temp_min": 24.25,
                "temp_max": 24.25,
                "pressure": 1018,
                "sea_level": 1018,
                "grnd_level": 1018,
                "humidity": 72,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 803,
                    "main": "Clouds",
                    "description": "broken clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 65
            },
            "wind": {
                "speed": 3.83,
                "deg": 59,
                "gust": 4.25
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2024-02-02 06:00:00"
        },
        {
            "dt": 1706864400,
            "main": {
                "temp": 24.48,
                "feels_like": 24.81,
                "temp_min": 24.48,
                "temp_max": 24.48,
                "pressure": 1016,
                "sea_level": 1016,
                "grnd_level": 1016,
                "humidity": 70,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 802,
                    "main": "Clouds",
                    "description": "scattered clouds",
                    "icon": "03d"
                }
            ],
            "clouds": {
                "all": 48
            },
            "wind": {
                "speed": 3.92,
                "deg": 59,
                "gust": 4.25
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2024-02-02 09:00:00"
        },
 }
"""
        return try! JSONDecoder().decode(ForecastResponse.self, from: Data(data.utf8)).list.map { $0.toUIModel() }
    }
    
}
