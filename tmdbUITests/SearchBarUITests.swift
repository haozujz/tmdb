//
//  SearchBarUITests.swift
//  tmdbUITests
//
//  Created by Joseph Zhu on 3/4/2023.
//

import XCTest

@MainActor
class SearchBarViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSearchBar() async {
        let searchBar = app.textFields["searchBar"]
        XCTAssertTrue(searchBar.exists, "Search bar does not exist")

        searchBar.tap()
        searchBar.typeText("Test Movie")

        let clearButtonFrame = searchBar.frame.insetBy(dx: -searchBar.frame.width * 0.25, dy: 0)
        let clearButton = app.images.allElementsBoundByIndex.first(where: { clearButtonFrame.contains($0.frame) })
        XCTAssertNotNil(clearButton, "Clear button does not exist")
        
        XCTAssertEqual(searchBar.value as! String, "Test Movie", "Search bar should be empty after tapping clear button")
    }
}
