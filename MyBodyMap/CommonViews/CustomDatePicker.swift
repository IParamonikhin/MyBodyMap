//
//  CustomDatePicker.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import SwiftUI

public struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    var foregroundStyle: AnyShapeStyle = AnyShapeStyle(Color("FontColor"))
    var backgroundColor: Color = Color("FontContrastColor")
    var cornerRadius: CGFloat = 12

    public init(
        selectedDate: Binding<Date>,
        foregroundStyle: some ShapeStyle = Color("FontColor"),
        backgroundColor: Color = Color("FontContrastColor"),
        cornerRadius: CGFloat = 12
    ) {
        self._selectedDate = selectedDate
        self.foregroundStyle = AnyShapeStyle(foregroundStyle)
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        Button {
            showSheet = true
        } label: {
            HStack(spacing: 8) {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(foregroundStyle)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            )
        }
        .sheet(isPresented: $showSheet) {
            DatePicker(
                "Выберите дату",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .padding()
        }
    }
    @State private var showSheet = false
}
