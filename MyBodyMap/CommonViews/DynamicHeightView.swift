//
//  DynamicHeightView.swift
//  MyBodyMap
//
//  Created by Иван on 28.07.2025.
//

import SwiftUI

struct DynamicHeightView<Content: View>: View {
    @Binding var height: CGFloat
    let content: () -> Content
    
    var body: some View {
        content()
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear { height = proxy.size.height }
                        .onChange(of: proxy.size.height, initial: true) { _, newHeight in
                            height = newHeight
                        }
                }
            )
    }
}
