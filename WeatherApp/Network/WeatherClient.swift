//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import Foundation


final class WeatherClient {
    let networkClient: NetworkClient
    let urlBuilder = URLBuilder()

    init(networkClient: NetworkClient? = nil) {
        self.networkClient = networkClient ?? DefaultNetworkClient()
    }

    func headers() -> Network.HTTPHeaders {
        [:]
    }
}
