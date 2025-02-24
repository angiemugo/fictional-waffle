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

    case genericError(message: String)
    case apiError(message: String)
    case decodingError(Error)
    case builderError(message: String)
    case locationError(message: String)

    var errorMessage: String {
        switch self {
        case .genericError(let message),
                .apiError(let message),
                .builderError(let message),
                .locationError(let message):
            return message
        case .decodingError(let error):
            return String(format: ErrorMessages.decodingError.rawValue, error.localizedDescription)
        }
    }
}

enum NetworkClientHelpers {
    struct ErrorModel: Decodable {
        let message: String
    }

    static func extractError(data: Data) throws {
        do {
            DebugEnvironment.log.trace("\(LogMessages.errorEncountered.rawValue) \(String(data: data, encoding: .utf8) ?? "")")
            let errorModel = try JSONDecoder().decode(ErrorModel.self, from: data)
            DebugEnvironment.log.debug("\(LogMessages.errorEncountered.rawValue) \(errorModel)")
            throw WeatherClientError.apiError(message: errorModel.message)
        } catch {
            DebugEnvironment.log.debug("\(LogMessages.errorEncountered.rawValue) \(error)")
            throw WeatherClientError.decodingError(error)
        }
    }
}
