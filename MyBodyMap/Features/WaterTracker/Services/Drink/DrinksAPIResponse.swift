//
//  DrinksAPIResponse.swift
//  MyBodyMap
//
//  Created by Иван on 27.07.2025.
//

import Foundation

struct DrinksAPIResponse: Decodable {
    let products: [DrinkProduct]
}

struct DrinkProduct: Decodable {
    let product_name: String?
    let brands: String?
    let code: String?
    let image_url: String?
    let quantity: String?
    let ingredients_text_ru: String?
}
