import XCTest
@testable import LumenTray

final class LumenScaleTests: XCTestCase {
    func testPortionFromHundredGrams() {
        // Given 200 kcal per 100 g and a 50 g slice
        let kcal100 = 200.0
        let grams = 50.0
        // When the portion is scaled
        let kcal = LumenScale.slice(perHundred: kcal100, grams: grams)
        // Then energy is 100 kcal
        XCTAssertEqual(kcal, 100, accuracy: 0.0001)
    }

    func testKilojouleFallback() {
        // Given only 418.4 kJ per 100 g
        let kilojoules = 418.4
        // When energy is resolved
        let kcal = LumenScale.energyKcal(kcal100: 0, kilojoules100: kilojoules)
        // Then kJ / 4.184 becomes 100 kcal
        XCTAssertEqual(kcal, 100, accuracy: 0.01)
    }

    func testPreferExplicitKcalOverKilojoules() {
        // Given both kcal and kJ
        // When energy is resolved
        let kcal = LumenScale.energyKcal(kcal100: 80, kilojoules100: 900)
        // Then the kcal field wins
        XCTAssertEqual(kcal, 80, accuracy: 0.0001)
    }

    func testMacroPackScalesTogether() {
        // Given 100 kcal / 10 p / 20 c / 5 f per 100 g and 250 g
        // When a pack is built
        let pack = LumenScale.pack(kcal100: 100, protein100: 10, carbs100: 20, fat100: 5, grams: 250)
        // Then every macro is ×2.5
        XCTAssertEqual(pack.kcal, 250, accuracy: 0.0001)
        XCTAssertEqual(pack.protein, 25, accuracy: 0.0001)
        XCTAssertEqual(pack.carbs, 50, accuracy: 0.0001)
        XCTAssertEqual(pack.fat, 12.5, accuracy: 0.0001)
    }
}
