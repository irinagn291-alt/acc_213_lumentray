import XCTest
@testable import LumenTray

final class LumenDayTotalTests: XCTestCase {
    func testEatenBitesOnSameDayAddUp() {
        // Given two 100 g eaten bites at 250 kcal / 100 g on the same day
        let day = Date(timeIntervalSince1970: 1_700_000_000)
        let goods = LumenGoods(
            sku: "lt-test-oat",
            title: "Test oat",
            brand: "Test",
            kcal100: 250,
            protein100: 8,
            carbs100: 40,
            fat100: 4,
            artName: nil,
            remoteThumb: nil
        )
        let first = LumenBite.from(goods: goods, grams: 100, slot: .firstLight, day: day, isPlan: false)
        let second = LumenBite.from(goods: goods, grams: 100, slot: .midday, day: day, isPlan: false)
        // When day totals run
        let sum = LumenScale.dayTotals(bites: [first, second], day: day)
        // Then energy is 500 kcal and protein is 16 g
        XCTAssertEqual(sum.kcal, 500, accuracy: 0.0001)
        XCTAssertEqual(sum.protein, 16, accuracy: 0.0001)
    }

    func testPlanBitesAreExcludedFromEatenTotals() {
        // Given one eaten bite and one plan bite on the same day
        let day = Date(timeIntervalSince1970: 1_700_086_400)
        let goods = LumenGoods(
            sku: "lt-test-rye",
            title: "Test rye",
            brand: "Test",
            kcal100: 200,
            protein100: 6,
            carbs100: 36,
            fat100: 2,
            artName: nil,
            remoteThumb: nil
        )
        let eaten = LumenBite.from(goods: goods, grams: 100, slot: .evening, day: day, isPlan: false)
        let planned = LumenBite.from(goods: goods, grams: 100, slot: .firstLight, day: day, isPlan: true)
        // When eaten-only totals run
        let sum = LumenScale.dayTotals(bites: [eaten, planned], day: day, eatenOnly: true)
        // Then only the eaten 200 kcal counts
        XCTAssertEqual(sum.kcal, 200, accuracy: 0.0001)
    }

    func testOtherDayDoesNotCount() {
        // Given a bite yesterday
        let calendar = Calendar.current
        let today = Date(timeIntervalSince1970: 1_700_172_800)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let goods = LumenGoods(
            sku: "lt-test-trout",
            title: "Test trout",
            brand: "Test",
            kcal100: 160,
            protein100: 20,
            carbs100: 0,
            fat100: 8,
            artName: nil,
            remoteThumb: nil
        )
        let bite = LumenBite.from(goods: goods, grams: 100, slot: .midday, day: yesterday, isPlan: false)
        // When totals ask for today
        let sum = LumenScale.dayTotals(bites: [bite], day: today, calendar: calendar)
        // Then the pack is zero
        XCTAssertEqual(sum, .zero)
    }
}
