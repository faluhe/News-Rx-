//
//  BookmarkEntity+CoreDataProperties.swift
//  News
//
//  Created by Ismailov Farrukh on 21/09/23.
//
//

import Foundation
import CoreData


extension BookmarkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkEntity> {
        return NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
    }

    @NSManaged public var desc: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

// MARK: Generated accessors for articles
extension BookmarkEntity {

    @objc(insertObject:inArticlesAtIndex:)
    @NSManaged public func insertIntoArticles(_ value: ArticlesEntity, at idx: Int)

    @objc(removeObjectFromArticlesAtIndex:)
    @NSManaged public func removeFromArticles(at idx: Int)

    @objc(insertArticles:atIndexes:)
    @NSManaged public func insertIntoArticles(_ values: [ArticlesEntity], at indexes: NSIndexSet)

    @objc(removeArticlesAtIndexes:)
    @NSManaged public func removeFromArticles(at indexes: NSIndexSet)

    @objc(replaceObjectInArticlesAtIndex:withObject:)
    @NSManaged public func replaceArticles(at idx: Int, with value: ArticlesEntity)

    @objc(replaceArticlesAtIndexes:withArticles:)
    @NSManaged public func replaceArticles(at indexes: NSIndexSet, with values: [ArticlesEntity])

    @objc(addArticlesObject:)
    @NSManaged public func addToArticles(_ value: ArticlesEntity)

    @objc(removeArticlesObject:)
    @NSManaged public func removeFromArticles(_ value: ArticlesEntity)

    @objc(addArticles:)
    @NSManaged public func addToArticles(_ values: NSOrderedSet)

    @objc(removeArticles:)
    @NSManaged public func removeFromArticles(_ values: NSOrderedSet)

}

extension BookmarkEntity : Identifiable {

}
