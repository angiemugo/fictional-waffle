//
//  PlistDataSource.swift
//  WeatherApp
//
//  Created by Angie Mugo on 21/02/2025.
//

import Foundation

func fetchAuthToken() -> String {
    guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
          let secrets = NSDictionary(contentsOfFile: path),
          let apiKey = secrets["API_KEY"] as? String else {
        fatalError("Failed to load API Key.")
    }
    return apiKey
}
