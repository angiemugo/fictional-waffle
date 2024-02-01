//
//  Color+Weather.swift
//  WeatherApp
//
//  Created by Angie Mugo on 01/02/2024.
//

import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: formattedHex).scanHexInt64(&rgb)

        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: alpha
        )
    }
}
