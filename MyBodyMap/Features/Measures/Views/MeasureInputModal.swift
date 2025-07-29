//
//  MeasureInputModal.swift
//  MyBodyMap
//
//  Created by Иван on 20.07.2025.
//

import SwiftUI

struct MeasureInputModal: View {
    let field: MeasuresFeature.MeasuresField
    @State var value: Double = 0
    var onSave: (Double) -> Void
    @State private var contentHeight: CGFloat = .zero
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Color("BGColor").ignoresSafeArea()
                .overlay(
                    ScrollView(showsIndicators: false) {
                        VStack() {
                            HStack{
                                Text(field.label)
                                    .font(.largeTitle.bold())
                                    .foregroundStyle(Color("FontColor"))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                Spacer()
                            }
                            CardView{
                                VStack() {
                                    HStack{
                                        Text("Введите значение:")
                                            .font(.title2.bold())
                                            .foregroundStyle(Color("FontColor"))
                                        Spacer()
                                    }
                                    ElementBackgroundView() {
                                        HStack{
                                            TextField("0", value: $value, format: .number)
                                                .keyboardType(.decimalPad)
                                                .padding(.horizontal, 4)
                                                .foregroundStyle(Color("FontColor"))
                                                .font(.system(size: 22, weight: .medium))
                                            Spacer()
                                            Text(field.rawValue == "weight" ? "кг" : "см")
                                                .padding(.horizontal, 4)
                                                .foregroundStyle(Color("FontColor"))
                                                .font(.system(size: 22, weight: .medium))
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            if let hint = MeasurementHints.hint(for: field.rawValue) {
                                CardView {
                                    VStack() {
                                        HStack{
                                            Text("Порядок измерений")
                                                .font(.title2.bold())
                                                .foregroundStyle(Color("FontColor"))
                                            Spacer()
                                        }
                                        ElementBackgroundView(height: contentHeight) {
                                            DynamicHeightView(height: $contentHeight) {
                                                Text(hint)
                                                    .font(.system(size: 18, weight: .medium))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(Color("FontColor"))
                                                    .padding(.vertical, 12)
                                            }
                                        }
                                        
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            
                            CardView{
                                HStack{
                                    Button("Отмена") {
                                        dismiss()
                                    }
                                    .buttonStyle(CustomButtonStyle())
                                    
                                    Button("Сохранить") {
                                        onSave(value)
                                        dismiss()
                                    }
                                    .buttonStyle(CustomButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                            
                        }
                    }
                )
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
