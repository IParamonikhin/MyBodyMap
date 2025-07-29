//
//  ScannerOverlayView.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import SwiftUI

struct ScannerOverlayView: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width * 0.8
            let height = width

            ZStack {
                Color.black.opacity(0.85)
                    .mask(
                        Rectangle()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: width, height: height / 2)
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                    .blendMode(.destinationOut)
                            )
                    )
                    .compositingGroup()
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: width, height: height / 2)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                VStack(spacing: 8) {
                    Image(systemName: "barcode.viewfinder")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.white)
                    Text("Наведи камеру на код")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
                .frame(width: width, height: height)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
