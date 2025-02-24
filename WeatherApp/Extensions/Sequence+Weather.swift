//
//  Sequence.swift
//  WeatherApp
//
//  Created by Angie Mugo on 21/02/2025.
//

import Foundation

extension Sequence {
    func asyncMap<T>(_ transform: @escaping (Iterator.Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values.append(transform(element))
        }
        return values
    }
}
