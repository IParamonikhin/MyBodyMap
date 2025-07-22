//
//  BodySilhouetteView.swift
//  MyBodyMap
//
//  Created by Иван on 20.07.2025.
//

import SwiftUI



struct BodySilhouetteView: View {
    var selectedField: MeasuresFeature.MeasuresField?
    var onSelect: (MeasuresFeature.MeasuresField) -> Void = { _ in }
    var gender: ProfileFeature.Gender

    private var borderShape: AnyShape {
        switch gender {
        case .male, .other:
            return AnyShape(MaleBodySilhouetteBorderShape())
        case .female:
            return AnyShape(FemaleBodySilhouetteBorderShape())
        }
    }
    private var fillShape: AnyShape {
        switch gender {
        case .male, .other:
            return AnyShape(MaleBodySilhouetteShape())
        case .female:
            return AnyShape(FemaleBodySilhouetteShape())
        }
    }
    private var bodyPoints: [BodyPoint] {
        switch gender {
        case .male, .other: return maleBodyPoints
        case .female: return femaleBodyPoints
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                borderShape
                    .stroke(Color.cyan.opacity(0.6), lineWidth: 8)
                    .blur(radius: 8)
                    .aspectRatio(0.45, contentMode: .fit)
                fillShape
                    .fill(Color("bodyColor2"))
                    .aspectRatio(0.45, contentMode: .fit)
                ForEach(bodyPoints) { point in
                    Button(action: { onSelect(point.id) }) {
                        PulseCircle(selected: selectedField == point.id)
                    }
                    .position(x: point.x * w, y: point.y * h)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color("backgroundColor"))
    }
}



struct PulseCircle: View {
    var selected: Bool
    var color: Color = .accentColor
    @State private var animate = false

    var body: some View {
        ZStack {
            if selected {
                Circle()
                    .fill(color.opacity(0.3))
                    .scaleEffect(animate ? 1.5 : 1)
                    .opacity(animate ? 0 : 1)
                    .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: false), value: animate)
            }
            Circle()
                .fill(selected ? color : Color.gray.opacity(0.8))
                .frame(width: 28, height: 28)
        }
        .onAppear { animate = true }
    }
}
