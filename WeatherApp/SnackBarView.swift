//
//  SnackBarView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 24/02/2025.
//

import SwiftUI

struct SnackbarView: View {
    @Binding public var show: Bool
    public var bgColor: Color
    public var txtColor: Color
    public var icon: String?
    public var iconColor: Color
    public var message: String

    public var body: some View {
        VStack {
            Spacer()
            if show {
                HStack(spacing: 12) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .resizable()
                            .foregroundColor(iconColor)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                    }

                    Text(message)
                        .foregroundColor(txtColor)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(bgColor)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.3), value: show)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    show = false
                }
            }
        }
    }
}

// MARK: - Snackbar Modifier
struct SnackbarModifier: ViewModifier {
    @Binding var show: Bool
    var bgColor: Color
    var txtColor: Color
    var icon: String?
    var iconColor: Color
    var message: String

    func body(content: Content) -> some View {
        ZStack {
            content
            SnackbarView(show: $show,
                         bgColor: bgColor,
                         txtColor: txtColor,
                         icon: icon,
                         iconColor: iconColor,
                         message: message)
        }
    }
}


#Preview {
    SnackbarView(show: .constant(true),
                 bgColor: Color.blue,
                 txtColor: Color.white,
                 iconColor: Color.white,
                 message: "Success")
}
