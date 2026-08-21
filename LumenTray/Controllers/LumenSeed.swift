import Foundation

enum LumenShelf {
    static let panes: [LumenGoods] = [
        LumenGoods(sku: "lt-oat-milk", title: "Glass oat milk", brand: "Nordic pane", kcal100: 46, protein100: 1.2, carbs100: 6.8, fat100: 1.5, artName: "FoodOatMilk", remoteThumb: nil),
        LumenGoods(sku: "lt-rye-crisp", title: "Rye crisp sheets", brand: "Nordic pane", kcal100: 366, protein100: 9.4, carbs100: 68, fat100: 5.1, artName: "FoodRyeCrisp", remoteThumb: nil),
        LumenGoods(sku: "lt-smoked-trout", title: "Smoked trout", brand: "Nordic pane", kcal100: 162, protein100: 21.4, carbs100: 0.3, fat100: 8.2, artName: "FoodSmokedTrout", remoteThumb: nil),
        LumenGoods(sku: "lt-cloudberry", title: "Cloudberry yogurt", brand: "Nordic pane", kcal100: 94, protein100: 4.1, carbs100: 12.6, fat100: 2.8, artName: "FoodCloudberry", remoteThumb: nil),
        LumenGoods(sku: "lt-dill-cucumber", title: "Dill cucumber", brand: "Nordic pane", kcal100: 18, protein100: 0.7, carbs100: 3.1, fat100: 0.2, artName: "FoodDillCucumber", remoteThumb: nil),
        LumenGoods(sku: "lt-birch-water", title: "Birch water", brand: "Nordic pane", kcal100: 8, protein100: 0.1, carbs100: 1.9, fat100: 0, artName: "FoodBirchWater", remoteThumb: nil),
        LumenGoods(sku: "lt-lingon-oat", title: "Lingon oat bowl", brand: "Nordic pane", kcal100: 118, protein100: 3.6, carbs100: 19.4, fat100: 2.9, artName: "FoodLingonOat", remoteThumb: nil),
        LumenGoods(sku: "lt-goat-cheese", title: "Soft goat cheese", brand: "Nordic pane", kcal100: 268, protein100: 18.2, carbs100: 1.1, fat100: 21.4, artName: "FoodGoatCheese", remoteThumb: nil)
    ]

    static func goods(sku: String) -> LumenGoods? {
        panes.first { $0.sku == sku }
    }
}

enum LumenSeed {
    static func plant(into vault: inout LumenVault) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        #if targetEnvironment(simulator)
        let eatenToday = vault.bites.contains { !$0.isPlan && calendar.isDate($0.dayStamp, inSameDayAs: today) }
        if vault.didPlantDemo && eatenToday { return }
        vault.didPlantDemo = false
        #endif
        guard !vault.didPlantDemo else { return }
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        if let oat = LumenShelf.goods(sku: "lt-lingon-oat") {
            vault.bites.append(LumenBite.from(goods: oat, grams: 220, slot: .firstLight, day: today, isPlan: false))
        }
        if let trout = LumenShelf.goods(sku: "lt-smoked-trout") {
            vault.bites.append(LumenBite.from(goods: trout, grams: 140, slot: .midday, day: today, isPlan: false))
        }
        if let yogurt = LumenShelf.goods(sku: "lt-cloudberry") {
            vault.bites.append(LumenBite.from(goods: yogurt, grams: 90, slot: .nibble, day: today, isPlan: false))
        }
        if let rye = LumenShelf.goods(sku: "lt-rye-crisp") {
            vault.bites.append(LumenBite.from(goods: rye, grams: 40, slot: .evening, day: tomorrow, isPlan: true))
        }
        if let dill = LumenShelf.goods(sku: "lt-dill-cucumber") {
            vault.bites.append(LumenBite.from(goods: dill, grams: 80, slot: .midday, day: tomorrow, isPlan: true))
        }
        if let goat = LumenShelf.goods(sku: "lt-goat-cheese") {
            vault.wishes.append(LumenWish.from(goat))
        }
        if let birch = LumenShelf.goods(sku: "lt-birch-water") {
            vault.wishes.append(LumenWish.from(birch))
        }
        vault.didPlantDemo = true
    }
}
