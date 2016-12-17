//
//  mixTests.swift
//  mixTests
//
//  Created by Ioannis Tornazakis on 13/12/16.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import XCTest
@testable import mix

class mixTests: XCTestCase {
    
    var vc = mix.ViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! mix.ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_get_x() {
        var x = self.vc.get_x(dextroseLiters: 0.25, mixPercentage: 0.002, xylocaineConcentration: 0.02)
        XCTAssert(x == 27.78)
        
        x = self.vc.get_x(dextroseLiters: 0.25, mixPercentage: 0.001, xylocaineConcentration: 0.02)
        XCTAssert(x == 13.16)
        
        x = self.vc.get_x(dextroseLiters: 0.25, mixPercentage: 0.02, xylocaineConcentration: 0.02)
        XCTAssert(x == Double.infinity)
        
        x = self.vc.get_x(dextroseLiters: 0.25, mixPercentage: 0.021, xylocaineConcentration: 0.02)
        XCTAssert(x < 0)
    }
}
