//
//  NetworkClientHelpers.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import Foundation


enum WeatherClientError: Error {
    case genericError(Error)
    case apiError(code: WeatherErrorCode, type: String, message: String)
    case bodyEncodingError(Error)
    case decodingError(Error)
    case unsupportedResponseError
    case builderError(message: String)
}

enum WeatherErrorCode: String {
    case invalidJson = "invalid_json"
    case invalidRequestURL = "invalid_request_url"
    case invalidRequest = "invalid_request"
    case validationError = "validation_error"
    case unauthorized = "unauthorized"
    case invalidToken = "invalid_auth_token"
    case genericError
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
            return .genericError(Network.Errors.HTTPError(code: response.statusCode))
        }
        
        return nil
        
    }
}
