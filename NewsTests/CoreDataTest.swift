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
    }

    override func tearDown() {
        // Clean up and delete all entities to ensure each test is independent
        deleteAllEntities()
        super.tearDown()
    }

    func testSaveEntity() {
        saveEntityAndAssert(bookmark: bookmark)
    }

    func testFetchEntity() {
        saveEntity(bookmark: bookmark)
        fetchEntitiesAndAssertCount(expectedCount: 1, bookmark: bookmark)
    }

    func testDeleteEntity() {
        saveEntity(bookmark: bookmark)
        deleteEntityAndFetchAssert(expectedCount: 0, bookmark: bookmark)
    }


    // MARK: - Helper Functions
    // This method now solely asserts after the entity has been saved.
    private func saveEntityAndAssert(bookmark: NewsSectionModel) {
        saveEntity(bookmark: bookmark)
        // Additional logic or assertions can be placed here if needed
    }

    // Delete entity and assert fetch count in separate steps
    private func deleteEntityAndFetchAssert(expectedCount: Int, bookmark: NewsSectionModel) {
        deleteEntity(bookmark: bookmark)
        fetchEntitiesAndAssertCount(expectedCount: expectedCount, bookmark: bookmark)
    }

    private func saveEntity(bookmark: NewsSectionModel) {
        let saveExpectation = expectation(description: "Save expectation")

        coreDataManager.saveEntity(bookmark) { result in
            switch result {
            case .success():
                saveExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to save: \(CoreDataError.saveFailed(error))")
            }
        }
        wait(for: [saveExpectation], timeout: 5)
    }

    // Fetch and assert without assuming prior actions within the same test
    private func fetchEntitiesAndAssertCount(expectedCount: Int, bookmark: NewsSectionModel) {
        let fetchExpectation = expectation(description: "Fetch expectation")

        coreDataManager.fetchEntities(BookmarkEntity.self, predicate: nil) { result in
            switch result {
            case .success(let storedEntities):
                XCTAssertEqual(storedEntities.count, expectedCount, "Unexpected number of entities stored.")
                if let savedEntity = storedEntities.first {
                    self.assertEntityMatchesBookmark(savedEntity, bookmark)
                }
                fetchExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to fetch entities: \(CoreDataError.fetchFailed(error))")
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }


    // Delete all entities helper for cleanup
    private func deleteAllEntities() {
        guard let persistentContainer = coreDataManager?.persistentContainer else {
            XCTFail("Failed to retrieve the persistent container")
            return
        }

        let context = persistentContainer.viewContext

        // Specifying the entity types to clear out. Repeat the process for each entity type if there are multiple.
        let entityNames = ["BookmarkEntity"]

        context.performAndWait {
            entityNames.forEach { entityName in
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try context.execute(deleteRequest)
                } catch let error as NSError {
                    XCTFail("Failed to delete entities of type \(entityName): \(error), \(error.userInfo)")
                }
            }

            do {
                try context.save()
            } catch let error as NSError {
                XCTFail("Failed to save context after deleting entities: \(error), \(error.userInfo)")
            }
        }
    }

    // Asserts that an entity matches the bookmark model
    private func assertEntityMatchesBookmark(_ entity: BookmarkEntity, _ bookmark: NewsSectionModel) {
        XCTAssertEqual(entity.title, bookmark.title)
        XCTAssertEqual(entity.urlToImage, bookmark.imageURL)
        XCTAssertEqual(entity.desc, bookmark.description)
        XCTAssertEqual(entity.url, bookmark.url)
    }

    // Separate deleteEntity for reusability and single responsibility
    private func deleteEntity(bookmark: NewsSectionModel) {
        let deleteExpectation = expectation(description: "Delete expectation")

        coreDataManager.deleteEntity(bookmark) { result in
            switch result {
            case .success():
                deleteExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to delete entity: \(CoreDataError.deleteFailed(error))")
            }
        }
        wait(for: [deleteExpectation], timeout: 5)
    }
}
