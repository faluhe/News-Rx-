//
//  NewsTests.swift
//  NewsTests
//
//  Created by Ismailov Farrukh on 10/08/23.
//

import XCTest
@testable import News
import CoreData

class CoreDataManagerTests: XCTestCase {

    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager(containerName: "News")
    }


    func testSaveAndFetchEntities() {
        // Given
        let bookmark = NewsSectionModel(title: "test", imageURL: "test", description: "test", url: "test")

        // When
        coreDataManager.saveEntity(bookmark)

        // Then
        let result = coreDataManager.fetchEntities(BookmarkEntity.self, predicate: nil)

        switch result {
        case .success(let storedEntities):
            print(storedEntities.count)
            XCTAssertEqual(storedEntities.count, 1, "Expected one entity to be stored.")
        case .failure(let error):
            XCTFail("Failed to fetch entities with error: \(error)")
        }
    }

    func testDeleteEntity() {
        // Given
        let bookmark = NewsSectionModel(title: "test", imageURL: "test", description: "test", url: "test")

        // When
        coreDataManager.deleteEntity(bookmark)

        // Then
        let afterDeletionFetchResult = coreDataManager.fetchEntities(BookmarkEntity.self, predicate: nil)

        switch afterDeletionFetchResult {
        case .success(let afterDeletionStoredEntities):
            XCTAssertEqual(afterDeletionStoredEntities.count, 0, "Expected no entities to be stored after deletion.")
        case .failure(let error):
            XCTFail("Failed to fetch entities with error: \(error)")
        }
    }
}
