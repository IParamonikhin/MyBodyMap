//
//  CustomMenuPicker.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import SwiftUI

public struct CustomMenuPicker<T: Hashable & CustomStringConvertible>: View {
    let title: String
    @Binding var selection: T
    let options: [T]
    var font: Font = .system(size: 15, weight: .semibold)
    var foregroundStyle: AnyShapeStyle = AnyShapeStyle(Color("FontColor"))
    var backgroundColor: Color = Color("FontContrastColor")
    var cornerRadius: CGFloat = 12

    public init(
        title: String,
        selection: Binding<T>,
        options: [T],
        font: Font = .system(size: 15, weight: .semibold),
        foregroundStyle: some ShapeStyle = Color("FontColor"),
        backgroundColor: Color = Color("FontContrastColor"),
        cornerRadius: CGFloat = 12
    ) {
        self.title = title
        self._selection = selection
        self.options = options
        self.font = font
        self.foregroundStyle = AnyShapeStyle(foregroundStyle)
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option.description) {
                    selection = option
                }
            }
        } label: {
            HStack {
                Text(selection.description)
                    .font(font)
                    .foregroundStyle(foregroundStyle)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(foregroundStyle)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            )
        }
    }
}
