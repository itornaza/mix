//
//  mixUITests.swift
//  mixUITests
//
//  Created by Ioannis Tornazakis on 13/12/16.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import XCTest

class mixUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUIElements() {
        let app = XCUIApplication()
        
        // Check elements exist
        XCTAssertEqual(app.textFields.count, 2)
        XCTAssertNotNil(app.buttons["1%"])
        XCTAssertNotNil(app.buttons["2%"])
        XCTAssertNotNil(app.textFields["waterVolume"])
        XCTAssertNotNil(app.textFields["mixtureConcentration"])
        XCTAssertEqual(app.staticTexts.matching(identifier: "result").count, 1)
        
        // Check results title is set appropriately
        app.buttons["Reset"].tap()
        app.buttons["1%"].tap()
        XCTAssertNotNil(app.staticTexts["Solution 1%"])
        app.buttons["2%"].tap()
        XCTAssertNotNil(app.staticTexts["Solution 2%"])

        app.textFields["waterVolume"].tap()
        app.textFields["waterVolume"].clearAndEnterText(text: "250")
        app.textFields["mixtureConcentration"].tap()
        app.textFields["mixtureConcentration"].clearAndEnterText(text: "0.5")
    }
}

extension XCUIElement {
    /**
     * Removes any current text in the field before typing in the new value
     * - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        let deleteString = stringValue.map { _ in convertFromXCUIKeyboardKey(XCUIKeyboardKey.delete) }.joined(separator: "")
      
        // In the Simulator, make sure 'Hardware -> Keyboard -> Connect hardware keyboard' is off
        self.typeText(deleteString)
        self.typeText(text)
    }
}

/// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromXCUIKeyboardKey(_ input: XCUIKeyboardKey) -> String {
	return input.rawValue
}
