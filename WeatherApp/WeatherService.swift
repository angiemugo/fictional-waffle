//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import Foundation


final class WeatherClient {
    private var apiToken: String? = nil
    let networkClient: NetworkClient
    let urlBuilder = URLBuilder()

    init(apiToken: String, networkClient: NetworkClient? = nil) {
        self.apiToken = apiToken
        self.networkClient = networkClient ?? DefaultNetworkClient(apiToken)
    }

    init(networkClient: NetworkClient? = nil) {
        self.networkClient = networkClient ?? DefaultNetworkClient(apiToken)
    }

    func headers() -> Network.HTTPHeaders {
        [:]
    }
}

class WeatherService {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func fetchWeatherToday() {

    }

    func fetchWeatherForecast() {

    }
}




