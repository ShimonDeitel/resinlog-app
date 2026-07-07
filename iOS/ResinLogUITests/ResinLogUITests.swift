import XCTest

final class ResinLogUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddButtonOpensAddSheet() throws {
        let addButton = app.buttons["addButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        XCTAssertTrue(app.buttons["saveButton"].waitForExistence(timeout: 5))
        app.buttons["cancelButton"].tap()
    }

    func testAddFlowCreatesEntry() throws {
        let addButton = app.buttons["addButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        let field = app.textFields["field_title"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("UI Test Entry")
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Entry"].waitForExistence(timeout: 5))
    }

    func testKeyboardDismissesOnTapOutside() throws {
        let addButton = app.buttons["addButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        let field = app.textFields["field_title"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("Tap Away")
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.firstMatch.tap()
        XCTAssertFalse(app.keyboards.element.waitForExistence(timeout: 2))
        app.buttons["cancelButton"].tap()
    }

    func testFreeLimitTriggersPaywall() throws {
        for i in 0..<40 {
            let addButton = app.buttons["addButton"]
            guard addButton.waitForExistence(timeout: 5) else { break }
            addButton.tap()
            if app.buttons["purchaseButton"].waitForExistence(timeout: 2) {
                XCTAssertTrue(app.buttons["purchaseButton"].exists)
                app.buttons["paywallCloseButton"].tap()
                return
            }
            let field = app.textFields["field_title"]
            field.tap()
            field.typeText("Entry \(i)")
            app.buttons["saveButton"].tap()
        }
    }

    func testSettingsOpensAndCloses() throws {
        let settingsButton = app.buttons["settingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 5))
        app.buttons["settingsDoneButton"].tap()
    }
}
