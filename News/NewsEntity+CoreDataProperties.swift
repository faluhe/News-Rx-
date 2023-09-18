//
//  NewsEntity+CoreDataProperties.swift
//  News
//
//  Created by Ismailov Farrukh on 07/09/23.
//
//

import Foundation
import CoreData


extension NewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsEntity> {
        return NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
    }

    @NSManaged public var status: String?
    @NSManaged public var totalResults: Double
    @NSManaged public var articles: NSOrderedSet?

}

// MARK: Generated accessors for articles
extension NewsEntity {

    @objc(addArticlesObject:)
    @NSManaged public func addToArticles(_ value: ArticlesEntity)

    @objc(removeArticlesObject:)
    @NSManaged public func removeFromArticles(_ value: ArticlesEntity)

    @objc(addArticles:)
    @NSManaged public func addToArticles(_ values: NSOrderedSet)

    @objc(removeArticles:)
    @NSManaged public func removeFromArticles(_ values: NSOrderedSet)

}

extension NewsEntity : Identifiable {

}
