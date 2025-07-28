//
//  CustomButtonStyleView.swift
//  MyBodyMap
//
//  Created by Иван on 27.07.2025.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var height: CGFloat = 48
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            .background(Color("FontContrastColor"))
            .foregroundStyle(Color("FontColor"))
            .cornerRadius(14)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .padding(.top, 8)
    }
}
