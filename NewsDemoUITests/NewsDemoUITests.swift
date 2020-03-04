// 
// NewsDemoUITests.swift
// 
// Created on 2/28/20.
// 

import XCTest

class NewsDemoUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testUI() {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        let title = tablesQuery.staticTexts["Galaxy Note 20 in development with 128GB of base storage - SamMobile"].exists
        print("title:", title)
        
        let navTitleTab1 = app.navigationBars.staticTexts["Top Headlines"].exists
        print("navTitleTab1:", navTitleTab1)
        XCTAssert(navTitleTab1)
        let navTitleTab2 = app.navigationBars.staticTexts["Custom News"].exists
        print("navTitleTab2:", navTitleTab2)
        XCTAssertEqual(navTitleTab2, false)
        
        let tabBarsQuery = app.tabBars
        let tabHomeExist = tabBarsQuery.buttons["Home"].exists
        print("tabHomeExist:", tabHomeExist)
        XCTAssert(tabHomeExist)
        let tabCategoryExist = tabBarsQuery.buttons["Category"].exists
        print("tabCategoryExist:", tabCategoryExist)
        XCTAssert(tabCategoryExist)
        let tabProfileExist = tabBarsQuery.buttons["Profile"].exists
        print("tabProfileExist:", tabProfileExist)
        XCTAssert(tabProfileExist)
    }
}
