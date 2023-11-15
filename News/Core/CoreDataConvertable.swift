//
//  CoreDataConvertable.swift
//  News
//
//  Created by Ismailov Farrukh on 14/11/23.
//

import Foundation
import CoreData

protocol ConvertibleToEntity {
    associatedtype ManagedObjectType: NSManagedObject
    func toEntity(context: NSManagedObjectContext) -> ManagedObjectType
}


extension Article: ConvertibleToEntity {
    typealias EntityType = ArticlesEntity

    func toEntity(context: NSManagedObjectContext) -> ArticlesEntity {
        // Implement conversion logic from Article to ArticlesEntity
        let articlesEntity = ArticlesEntity(context: context)
        articlesEntity.title = self.title
        articlesEntity.descript = self.description
        articlesEntity.imgUrl = self.urlToImage
        articlesEntity.url = self.url

        if let source = self.source {
            let sourceEntity = SourcesEntity(context: context)
            sourceEntity.name = source.name
            sourceEntity.id = source.id
            articlesEntity.source = sourceEntity
        }
        return articlesEntity
    }
}

extension News: ConvertibleToEntity {
    typealias EntityType = NewsEntity

    func toEntity(context: NSManagedObjectContext) -> NewsEntity {
        // Implement conversion logic from News to NewsEntity
        let newsEntity = NewsEntity(context: context)
        newsEntity.status = self.status
        newsEntity.totalResults = self.totalResults ?? 0

        if let articles = self.articles {
            let articleEntities = articles.map { article in
                return article.toEntity(context: context)
            }
            newsEntity.articles = NSOrderedSet(array: articleEntities)
        }

        return newsEntity
    }
}


extension NewsSectionModel: ConvertibleToEntity {
    typealias EntityType = BookmarkEntity

    func toEntity(context: NSManagedObjectContext) -> BookmarkEntity {
        let existingEntity = self.existingEntity(in: context)

        if let existingEntity = existingEntity {
            // If the entity already exists, update its properties
            existingEntity.title = self.title
            existingEntity.desc = self.description
            existingEntity.url = self.url
            existingEntity.urlToImage = self.imageURL
            return existingEntity
        } else {
            // If the entity doesn't exist, create a new one
            let bookmarkEntity = BookmarkEntity(context: context)
            bookmarkEntity.title = self.title
            bookmarkEntity.desc = self.description
            bookmarkEntity.url = self.url
            bookmarkEntity.urlToImage = self.imageURL
            return bookmarkEntity
        }
    }

    private func existingEntity(in context: NSManagedObjectContext) -> BookmarkEntity? {
        let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", self.title)

        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching existing entity: \(error)")
            return nil
        }
    }
}



