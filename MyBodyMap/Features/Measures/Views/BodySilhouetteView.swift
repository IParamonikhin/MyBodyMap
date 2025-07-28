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
    var latestMeasures: [String: Measure] 

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
    
    func checkTodayMeasured(for field: MeasuresFeature.MeasuresField) -> Bool {
        // latestMeasures — это [String: Measure]
        guard let measure = latestMeasures[field.rawValue] else { return false }
        return Calendar.current.isDateInToday(measure.date)
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
                    .fill(Color("BodyColor"))
                    .aspectRatio(0.45, contentMode: .fit)
                ForEach(bodyPoints) { point in
                    let isTodayMeasured = checkTodayMeasured(for: point.id)
                    Button(action: { onSelect(point.id) }) {
                        PulseCircle(isTodayMeasured: isTodayMeasured)
                    }
                    .position(x: point.x * w, y: point.y * h)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color("BGColor"))
    }
}



struct PulseCircle: View {
    var isTodayMeasured: Bool
    @State private var animate = false

    var body: some View {
        let color = isTodayMeasured ? Color.green : Color.gray
        ZStack {
            // Большой круг
            Circle()
                .fill(color.opacity(0.5))
                .frame(width: 35, height: 35)
                .scaleEffect(animate ? 1.35 : 1.0)
                .blur(radius: 8)
                .opacity(animate ? 0.5 : 0.8)
                .animation(.easeOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)
            // Малый круг
            Circle()
                .fill(color.opacity(0.5))
                .frame(width: 28, height: 28)
                .blur(radius: 1)
                .opacity(animate ? 0.7 : 1.0)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear { animate = true }
    }
}
