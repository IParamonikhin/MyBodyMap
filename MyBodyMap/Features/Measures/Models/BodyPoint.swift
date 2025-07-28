//
//  BodyPoint.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation

struct BodyPoint: Identifiable {
    let id: MeasuresFeature.MeasuresField
    let x: CGFloat // 0...1
    let y: CGFloat // 0...1
}

let maleBodyPoints: [BodyPoint] = [
    .init(id: .height,    x: 0.5,  y: 0.02),  //Рост
    .init(id: .neck,      x: 0.5,  y: 0.15),  //Шея
    .init(id: .shoulders, x: 0.71, y: 0.20),  //Плечи
    .init(id: .chest,     x: 0.5,  y: 0.26),  //Грудь
    .init(id: .biceps,    x: 0.23, y: 0.30),  //Бицепс
    .init(id: .waist,     x: 0.5,  y: 0.36),  //Талия
    .init(id: .forearm,   x: 0.19, y: 0.40),  //Предплечье
    .init(id: .stomach,   x: 0.5,  y: 0.44),  //Живот
    .init(id: .buttocks,  x: 0.65,  y: 0.53), //Ягодицы
    .init(id: .thigh,     x: 0.34, y: 0.60),  //Бедро
    .init(id: .calf,      x: 0.31, y: 0.78),  //Икра
    .init(id: .weight,    x: 0.5,  y: 0.98),  //Вес
]

let femaleBodyPoints: [BodyPoint] = [
    .init(id: .height,    x: 0.5,  y: 0.02),  //Рост
    .init(id: .neck,      x: 0.5,  y: 0.15),  //Шея
    .init(id: .shoulders, x: 0.69, y: 0.20),  //Плечи
    .init(id: .chest,     x: 0.5,  y: 0.24),  //Грудь
    .init(id: .biceps,    x: 0.265, y: 0.28), //Бицепс
    .init(id: .waist,     x: 0.5,  y: 0.34),  //Талия
    .init(id: .forearm,   x: 0.215, y: 0.37), //Предплечье
    .init(id: .stomach,   x: 0.5,  y: 0.40),  //Живот
    .init(id: .buttocks,  x: 0.63,  y: 0.46), //Ягодицы
    .init(id: .thigh,     x: 0.34, y: 0.57),  //Бедро
    .init(id: .calf,      x: 0.29, y: 0.78),  //Икра
    .init(id: .weight,    x: 0.5,  y: 0.98),  //Вес
]
