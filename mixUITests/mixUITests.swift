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
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUIElements() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        let deleteString = stringValue.characters.map { _ in XCUIKeyboardKeyDelete }.joined(separator: "")
        self.typeText(deleteString)
        self.typeText(text)
    }
}
