//
//  NewsUITests.swift
//  NewsUITests
//
//  Created by Ismailov Farrukh on 10/08/23.
//

import XCTest

final class NewsUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testBookmarksRemoving() throws {
        let app = XCUIApplication()
        app.launch()

        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells.element(boundBy: 0).tap()

        app.navigationBars["News.DetailsView"].buttons["bookmark"].tap()

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Home"].tap()

        tabBar.buttons["Bookmark"].tap()

        collectionViewsQuery.cells.element(boundBy: 0).press(forDuration: 1.0)

        app.alerts["Delete Bookmark"].scrollViews.otherElements.buttons["Delete"].tap()
    }
}
