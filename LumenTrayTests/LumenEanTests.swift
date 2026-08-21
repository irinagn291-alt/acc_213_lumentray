import XCTest
@testable import LumenTray

final class LumenEanTests: XCTestCase {
    func testUpcTwelveGetsLeadingZero() {
        // Given a raw UPC-12
        let raw = "123456789012"
        // When the glyph is normalized
        let code = LumenEan.normalize(raw)
        // Then a leading zero makes EAN-13
        XCTAssertEqual(code, "0123456789012")
    }

    func testDigitsPulledFromProductURL() {
        // Given an Open Food Facts product URL
        let raw = "https://world.openfoodfacts.org/product/3017620422003/nutella"
        // When digits are lifted from the URL
        let code = LumenEan.normalize(raw)
        // Then the 13-digit run is kept
        XCTAssertEqual(code, "3017620422003")
    }

    func testEightToFourteenDigitsStay() {
        // Given an EAN-8
        let raw = "12345670"
        // When normalized
        let code = LumenEan.normalize(raw)
        // Then the eight digits stay
        XCTAssertEqual(code, "12345670")
    }

    func testShortRunIsRejected() {
        // Given only seven digits
        let raw = "abc1234567"
        // When normalized
        let code = LumenEan.normalize(raw)
        // Then there is no glyph
        XCTAssertNil(code)
    }
}
