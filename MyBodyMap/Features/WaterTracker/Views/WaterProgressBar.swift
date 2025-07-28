//
//  WaterProgressBar.swift
//  MyBodyMap
//
//  Created by Иван on 28.07.2025.
//

import SwiftUI

struct WaterProgressBar: View {
    let intake: Double
    let goal: Double
    let isPulsing: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("TextfieldColor"))
                .frame(height: 48)
            GeometryReader { geo in
                let width = max(12, CGFloat(intake / max(1, goal)) * (geo.size.width))
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.cyan)
                        .blur(radius: isPulsing ? 5 : 3)
                        .opacity(isPulsing ? 0.7 : 1.0)
                        .frame(width: min(width, geo.size.width), height: 48)
                        .animation(.easeInOut(duration: 1.2), value: isPulsing)
                        .animation(.easeInOut, value: intake)
                    if intake > goal {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.green)
                            .blur(radius: isPulsing ? 5 : 3)
                            .opacity(isPulsing ? 0.7 : 1.0)
                            .frame(
                                width: min(width - (geo.size.width - 16), geo.size.width),
                                height: 48
                            )
                            .animation(.easeInOut(duration: 1.2), value: isPulsing)
                            .animation(.easeInOut, value: intake)
                    }
                }
            }.frame(height: 48)
            
            Text("\(Int(intake)) из \(Int(goal)) мл")
                .font(.title2)
                .bold()
                .foregroundStyle(Color("BodyColor"))
        }
    }
}
