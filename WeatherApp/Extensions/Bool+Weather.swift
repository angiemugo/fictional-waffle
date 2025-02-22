//
//  Bool+Weather.swift
//  WeatherApp
//
//  Created by Angie Mugo on 21/02/2025.
//

import Foundation

extension Bool: @retroactive Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        !lhs && rhs
    }
}
