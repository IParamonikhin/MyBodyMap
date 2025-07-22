//
//  CardView.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: () -> Content
    var body: some View {
        VStack {
            content()
        }
        .padding()
        .background(Color("bodyColor"))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 2)
    }
}

//#Preview {
//    CardView()
//}
