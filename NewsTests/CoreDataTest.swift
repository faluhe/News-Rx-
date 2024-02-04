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
    let bookmark = NewsSectionModel(title: "test", imageURL: "test", description: "test", url: "test")

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager(containerName: "News")
        saveEntityAndAssert(bookmark: bookmark)
        fetchEntitiesAndAssertCount(expectedCount: 1, bookmark: bookmark)
        deleteEntityAndFetchAssert(expectedCount: 0, bookmark: bookmark)
    }


    // Helper function to save the entity and assert success
    private func saveEntityAndAssert(bookmark: NewsSectionModel) {
        let saveExpectation = expectation(description: "Save expectation")

        coreDataManager.saveEntity(bookmark) { result in
            switch result {
            case .success:
                saveExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to save: \(CoreDataError.saveFailed(error))")
            }
        }
        wait(for: [saveExpectation], timeout: 5)
    }

    // Helper function to fetch entities and assert count and content
    private func fetchEntitiesAndAssertCount(expectedCount: Int, bookmark: NewsSectionModel) {
        let fetchExpectation = expectation(description: "Fetch expectation")

        coreDataManager.fetchEntities(BookmarkEntity.self, predicate: nil) { result in
            switch result {
            case .success(let storedEntities):
                XCTAssertEqual(storedEntities.count, expectedCount, "Unexpected number of entities stored.")

                guard let savedEntity = storedEntities.first else {
                    XCTFail("No entities found in the database after save.")
                    return }

                self.assertEntityMatchesBookmark(savedEntity, bookmark)

                fetchExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to fetch entities: \(CoreDataError.fetchFailed(error))")
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }


    // Helper function to delete the entity and assert success
    private func deleteEntityAndFetchAssert(expectedCount: Int, bookmark: NewsSectionModel) {
        let deleteExpectation = expectation(description: "Delete expectation")

        coreDataManager.deleteEntity(bookmark) { result in
            switch result {
            case .success:
                deleteExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to delete entity: \(CoreDataError.deleteFailed(error))")
            }
        }
        wait(for: [deleteExpectation], timeout: 5)


        // Verify that the entity has been deleted
        let fetchExpectation = self.expectation(description: "Fetch after deletion expectation")
        coreDataManager.fetchEntities(BookmarkEntity.self, predicate: nil) { result in
            switch result {
            case .success(let storedEntities):
                XCTAssertEqual(storedEntities.count, expectedCount, "Expected no entities to be stored after deletion.")
                fetchExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to fetch entities after deletion: \(CoreDataError.fetchFailed(error))")
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }


    // Helper function to assert entity matches bookmark
    private func assertEntityMatchesBookmark(_ entity: BookmarkEntity, _ bookmark: NewsSectionModel) {
        XCTAssertEqual(entity.title, bookmark.title, "Saved entity's title does not match.")
        XCTAssertEqual(entity.urlToImage, bookmark.imageURL, "Saved entity's imageURL does not match.")
        XCTAssertEqual(entity.desc, bookmark.description, "Saved entity's description does not match.")
        XCTAssertEqual(entity.url, bookmark.url, "Saved entity's URL does not match.")
    }
}
