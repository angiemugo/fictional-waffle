//
//  View+Weather.swift
//  WeatherApp
//
//  Created by Angie Mugo on 24/02/2025.
//

import SwiftUI

extension View {
    func snackbar(show: Binding<Bool>,
                  bgColor: Color = .blue,
                  txtColor: Color = .white,
                  icon: String? = nil,
                  iconColor: Color = .white,
                  message: String) -> some View {
        self.modifier(SnackbarModifier(show: show,
                                       bgColor: bgColor,
                                       txtColor: txtColor,
                                       icon: icon,
                                       iconColor: iconColor,
                                       message: message))
    }
}

