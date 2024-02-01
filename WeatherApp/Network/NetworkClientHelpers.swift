//
//  NetworkClientHelpers.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import Foundation


enum WeatherClientError: Error, Identifiable {
    var id: String {
          return UUID().uuidString
      }

    case genericError(Error)
    case apiError(message: String)
    case bodyEncodingError(Error)
    case decodingError(Error)
    case unsupportedResponseError
    case builderError(message: String)
    case locationError(message: String)
}


enum NetworkClientHelpers {
    static func extractError(response: URLResponse?, error: Error?) -> WeatherClientError? {
        if let error = error {
            return .genericError(error)
        }
        
        guard let response = response as? HTTPURLResponse else {
            return .unsupportedResponseError
        }
        
        if (400..<503).contains(response.statusCode) {
            return .apiError(message: response.debugDescription)
        }
        
        return nil
    }
}
