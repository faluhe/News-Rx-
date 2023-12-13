//
//  NetworkTest.swift
//  NewsTests
//
//  Created by Ismailov Farrukh on 08/12/23.
//

import XCTest
@testable import News

class NetworkTests: XCTestCase {

    var sessionUnderTest: URLSession!

    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }

    func testValidCallStatus() {

        // Given
        let path = URL(string: HomeTarget.getNews.path)

        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?

        // When
        let dataTask = sessionUnderTest.dataTask(with: path!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()

        waitForExpectations(timeout: 5, handler: nil)

        // Then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}

