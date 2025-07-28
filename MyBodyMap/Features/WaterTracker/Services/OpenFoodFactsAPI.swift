//
//  OpenFoodFactsAPI.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import Foundation
import ComposableArchitecture

public struct OpenFoodFactsProduct: Decodable, Equatable {
    let product_name: String?
    let brands: String?
    let code: String?
    let quantity: String?
    let image_url: String?
    let ingredients_text_ru: String?
}
public struct OpenFoodFactsProductResponse: Decodable {
    public let code: String
    public let product: OpenFoodFactsProduct?
    public let status: Int?
    public let status_verbose: String?
}
public protocol FoodFactsAPI {
    func fetchProduct(barcode: String) async -> OpenFoodFactsProduct?
}
public struct LiveFoodFactsAPI: FoodFactsAPI {
    public func fetchProduct(barcode: String) async -> OpenFoodFactsProduct? {
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v2/product/\(barcode)") else {
            print("Ошибка: невалидный URL для штрихкода \(barcode)")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let root = try JSONDecoder().decode(OpenFoodFactsProductResponse.self, from: data)
            return root.product
        } catch {
            print("API error: \(error)")
            return nil
        }
    }
}
private enum FoodFactsAPIKey: DependencyKey {
    static let liveValue: FoodFactsAPI = LiveFoodFactsAPI()
}
extension DependencyValues {
    var foodFactsAPI: FoodFactsAPI {
        get { self[FoodFactsAPIKey.self] }
        set { self[FoodFactsAPIKey.self] = newValue }
    }
}
