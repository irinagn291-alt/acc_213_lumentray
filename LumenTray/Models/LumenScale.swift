import Foundation

struct LumenMacroPack: Equatable, Sendable {
    var kcal: Double
    var protein: Double
    var carbs: Double
    var fat: Double

    static let zero = LumenMacroPack(kcal: 0, protein: 0, carbs: 0, fat: 0)

    static func + (lhs: LumenMacroPack, rhs: LumenMacroPack) -> LumenMacroPack {
        LumenMacroPack(
            kcal: lhs.kcal + rhs.kcal,
            protein: lhs.protein + rhs.protein,
            carbs: lhs.carbs + rhs.carbs,
            fat: lhs.fat + rhs.fat
        )
    }
}

enum LumenScale {
    static func slice(perHundred: Double, grams: Double) -> Double {
        perHundred * grams / 100.0
    }

    static func kcalFromKilojoules(_ kilojoules: Double) -> Double {
        kilojoules / 4.184
    }

    static func energyKcal(kcal100: Double?, kilojoules100: Double?) -> Double {
        if let kcal100, kcal100 > 0 { return kcal100 }
        if let kilojoules100, kilojoules100 > 0 { return kcalFromKilojoules(kilojoules100) }
        return kcal100 ?? 0
    }

    static func pack(
        kcal100: Double,
        protein100: Double,
        carbs100: Double,
        fat100: Double,
        grams: Double
    ) -> LumenMacroPack {
        LumenMacroPack(
            kcal: slice(perHundred: kcal100, grams: grams),
            protein: slice(perHundred: protein100, grams: grams),
            carbs: slice(perHundred: carbs100, grams: grams),
            fat: slice(perHundred: fat100, grams: grams)
        )
    }

    static func dayTotals(
        bites: [LumenBite],
        day: Date,
        eatenOnly: Bool = true,
        calendar: Calendar = .current
    ) -> LumenMacroPack {
        bites
            .filter { calendar.isDate($0.dayStamp, inSameDayAs: day) }
            .filter { eatenOnly ? !$0.isPlan : true }
            .map(\.macros)
            .reduce(.zero, +)
    }
}
