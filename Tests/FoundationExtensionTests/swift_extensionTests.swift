import XCTest
@testable import swift_extension

final class swift_extensionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_extension().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
