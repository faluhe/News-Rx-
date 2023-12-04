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

    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataManager = CoreDataManager(containerName: "News")
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
        try super.tearDownWithError()
    }

    func testSaveAndFetchEntities() {
        // Create a test entity
        let bookmark = NewsSectionModel(title: "test", imageURL: "test", description: "test", url: "test")

        // Save the entity
        coreDataManager.saveEntity(bookmark)

        // Fetch the entities
        let result = coreDataManager.fetchEntities(BookmarkEntity.self, predicate: nil)

        switch result {
        case .success(let storedEntities):
            XCTAssertEqual(storedEntities.count, 1, "Expected one entity to be stored.")
            // Add additional assertions based on your data model
        case .failure(let error):
            XCTFail("Failed to fetch entities with error: \(error)")
        }
    }

    func testDeleteEntity() {
        // Create a test entity
        let bookmark = NewsSectionModel(title: "test", imageURL: "test", description: "test", url: "test")

        // Delete the entity
        coreDataManager.deleteEntity(bookmark)

        // Fetch the entities after deletion
        let afterDeletionFetchResult = coreDataManager.fetchEntities(BookmarkEntity.self, predicate: nil)

        switch afterDeletionFetchResult {
        case .success(let afterDeletionStoredEntities):
            XCTAssertEqual(afterDeletionStoredEntities.count, 0, "Expected no entities to be stored after deletion.")
        case .failure(let error):
            XCTFail("Failed to fetch entities with error: \(error)")
        }
    }
}
