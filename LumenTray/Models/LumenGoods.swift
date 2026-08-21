import Foundation

struct LumenGoods: Identifiable, Hashable, Codable, Sendable {
    var sku: String
    var title: String
    var brand: String
    var kcal100: Double
    var protein100: Double
    var carbs100: Double
    var fat100: Double
    var artName: String?
    var remoteThumb: String?

    var id: String { sku }

    var perHundred: LumenMacroPack {
        LumenMacroPack(kcal: kcal100, protein: protein100, carbs: carbs100, fat: fat100)
    }
}

enum LumenHuntHop: Hashable {
    case card(LumenGoods)
    case seat(LumenGoods)
}
