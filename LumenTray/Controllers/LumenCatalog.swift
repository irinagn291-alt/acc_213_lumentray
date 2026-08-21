import Foundation

enum LumenCatalogError: Error, Equatable {
    case badURL
    case empty
    case missingProduct
}

enum LumenCatalog {
    static let agent = "LumenTray/1.0 (iOS; glass diary; lumen.tray.glass@example.com)"

    static func hunt(_ query: String) async throws -> [LumenGoods] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        var parts = URLComponents(string: "https://world.openfoodfacts.org/cgi/search.pl")
        parts?.queryItems = [
            URLQueryItem(name: "search_terms", value: trimmed),
            URLQueryItem(name: "search_simple", value: "1"),
            URLQueryItem(name: "action", value: "process"),
            URLQueryItem(name: "json", value: "1"),
            URLQueryItem(name: "page_size", value: "24")
        ]
        guard let url = parts?.url else { throw LumenCatalogError.badURL }
        let root = try await pullJSON(url)
        let products = root["products"] as? [[String: Any]] ?? []
        let mapped = products.compactMap(mapProduct)
        if mapped.isEmpty { throw LumenCatalogError.empty }
        return mapped
    }

    static func pane(_ raw: String) async throws -> LumenGoods {
        guard let code = LumenEan.normalize(raw) else { throw LumenCatalogError.badURL }
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v2/product/\(code).json") else {
            throw LumenCatalogError.badURL
        }
        let root = try await pullJSON(url)
        let status = (root["status"] as? Int) ?? 0
        guard status == 1, let product = root["product"] as? [String: Any], let goods = mapProduct(product) else {
            throw LumenCatalogError.missingProduct
        }
        return goods
    }

    private static func pullJSON(_ url: URL) async throws -> [String: Any] {
        var request = URLRequest(url: url)
        request.setValue(agent, forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 20
        let (data, _) = try await URLSession.shared.data(for: request)
        let object = try JSONSerialization.jsonObject(with: data)
        return object as? [String: Any] ?? [:]
    }

    static func mapProduct(_ product: [String: Any]) -> LumenGoods? {
        let sku = string(product["code"]) ?? string(product["_id"]) ?? UUID().uuidString
        let title = firstNonEmpty(
            string(product["product_name"]),
            string(product["product_name_en"]),
            string(product["generic_name"])
        ) ?? "Glass find"
        let brand = string(product["brands"]) ?? ""
        let nutriments = product["nutriments"] as? [String: Any] ?? [:]
        let kcalRaw = number(nutriments, keys: ["energy-kcal_100g", "energy-kcal", "energy_kcal_100g"])
        let kiloJoules = number(nutriments, keys: ["energy_100g", "energy-kj_100g", "energy"])
        let kcal100 = LumenScale.energyKcal(kcal100: kcalRaw, kilojoules100: kiloJoules)
        return LumenGoods(
            sku: sku,
            title: title,
            brand: brand,
            kcal100: kcal100,
            protein100: number(nutriments, keys: ["proteins_100g", "proteins"]),
            carbs100: number(nutriments, keys: ["carbohydrates_100g", "carbohydrates"]),
            fat100: number(nutriments, keys: ["fat_100g", "fat"]),
            artName: nil,
            remoteThumb: string(product["image_front_small_url"]) ?? string(product["image_small_url"])
        )
    }

    private static func firstNonEmpty(_ values: String?...) -> String? {
        values.compactMap { $0 }.first { !$0.isEmpty }
    }

    private static func string(_ value: Any?) -> String? {
        if let text = value as? String {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
        if let number = value as? NSNumber { return number.stringValue }
        return nil
    }

    private static func number(_ bag: [String: Any], keys: [String]) -> Double {
        for key in keys {
            if let value = bag[key] as? Double { return value }
            if let value = bag[key] as? Int { return Double(value) }
            if let value = bag[key] as? NSNumber { return value.doubleValue }
            if let value = bag[key] as? String, let parsed = Double(value) { return parsed }
        }
        return 0
    }
}
