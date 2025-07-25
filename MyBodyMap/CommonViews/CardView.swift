//
//  CardView.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack { content() }
            .padding()
            .background(Color("ContrastColor"))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 2)
    }
}
