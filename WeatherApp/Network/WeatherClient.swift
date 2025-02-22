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

    var headers: Network.HTTPHeaders {
        [:]
    }

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}
