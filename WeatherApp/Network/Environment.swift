//
//  Environment.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import Foundation

typealias DebugEnvironment = WeatherAppEnvironment

struct WeatherAppEnvironment {
    static var log = Logger(handler: PrintLogHandler(), level: .info)
    static var logHandler: LoggerHandler {
        get { log.handler }
        set { log.handler = newValue }
    }
    
    static var logLevel: LogLevel {
        get { log.level }
        set { log.level = newValue }
    }
}
