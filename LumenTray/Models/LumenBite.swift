import Foundation

struct LumenBite: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var dayStamp: Date
    var slot: LumenSlot
    var sku: String
    var title: String
    var grams: Double
    var kcal100: Double
    var protein100: Double
    var carbs100: Double
    var fat100: Double
    var isPlan: Bool

    var macros: LumenMacroPack {
        LumenScale.pack(
            kcal100: kcal100,
            protein100: protein100,
            carbs100: carbs100,
            fat100: fat100,
            grams: grams
        )
    }

    static func from(goods: LumenGoods, grams: Double, slot: LumenSlot, day: Date, isPlan: Bool) -> LumenBite {
        LumenBite(
            id: UUID(),
            dayStamp: Calendar.current.startOfDay(for: day),
            slot: slot,
            sku: goods.sku,
            title: goods.title,
            grams: grams,
            kcal100: goods.kcal100,
            protein100: goods.protein100,
            carbs100: goods.carbs100,
            fat100: goods.fat100,
            isPlan: isPlan
        )
    }
}

struct LumenWish: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var sku: String
    var title: String
    var kcal100: Double
    var protein100: Double
    var carbs100: Double
    var fat100: Double
    var artName: String?

    func asGoods() -> LumenGoods {
        LumenGoods(
            sku: sku,
            title: title,
            brand: "Wish pane",
            kcal100: kcal100,
            protein100: protein100,
            carbs100: carbs100,
            fat100: fat100,
            artName: artName,
            remoteThumb: nil
        )
    }

    static func from(_ goods: LumenGoods) -> LumenWish {
        LumenWish(
            id: UUID(),
            sku: goods.sku,
            title: goods.title,
            kcal100: goods.kcal100,
            protein100: goods.protein100,
            carbs100: goods.carbs100,
            fat100: goods.fat100,
            artName: goods.artName
        )
    }
}

struct LumenAims: Codable, Hashable, Sendable {
    var kcal: Double
    var protein: Double
    var carbs: Double
    var fat: Double

    static let factory = LumenAims(kcal: 1680, protein: 88, carbs: 172, fat: 58)
}

struct LumenVault: Codable, Sendable {
    var aims: LumenAims
    var bites: [LumenBite]
    var wishes: [LumenWish]
    var didFinishOnboard: Bool
    var didPlantDemo: Bool

    static let empty = LumenVault(
        aims: .factory,
        bites: [],
        wishes: [],
        didFinishOnboard: false,
        didPlantDemo: false
    )
}
