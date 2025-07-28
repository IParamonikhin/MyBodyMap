//
//  CustomSegmentedPickerView.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import SwiftUI

public struct CustomSegmentedPickerView<T: CaseIterable & Equatable & Hashable & Identifiable & CustomStringConvertible>: View where T.AllCases: RandomAccessCollection {
    @Binding var selection: T

    let items: [T]
    let selectedColor: Color
    let unselectedColor: Color
    let fontColor: Color
    let cornerRadius: CGFloat

    public init(
        selection: Binding<T>,
        items: [T] = Array(T.allCases),
        selectedColor: Color = Color("FontContrastColor"),
        unselectedColor: Color = Color.clear,
        fontColor: Color = Color("FontColor"),
        cornerRadius: CGFloat = 12
    ) {
        self._selection = selection
        self.items = items
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.fontColor = fontColor
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.self) { value in
                Button {
                    selection = value
                } label: {
                    Text(value.description)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(selection == value ? fontColor : fontColor.opacity(0.7))
                        .frame(maxWidth: .infinity, minHeight: 36)
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius - 2)
                                .fill(selection == value ? selectedColor : unselectedColor)
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(2)
        .background(unselectedColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .animation(.easeInOut, value: selection)
    }
}
