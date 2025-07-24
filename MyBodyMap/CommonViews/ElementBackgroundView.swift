//
//  ElementBackgroundView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI

struct ElementBackgroundView<Content: View>: View {
    let height: CGFloat
    let content: Content

    init(height: CGFloat = 48, @ViewBuilder content: () -> Content) {
        self.height = height
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("TextfieldColor"))
                .frame(height: height)
            content
                .padding(.horizontal, 12)
        }
        .padding(.horizontal, 4)
    }
}
