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

//MARK: - Checking existing Entity in the context.
extension ConvertibleToEntity {
    func existingEntity<T: NSManagedObject>(in context: NSManagedObjectContext, predicate: NSPredicate?) -> T? {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.predicate = predicate

        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching existing entity: \(error)")
            return nil
        }
    }
}

extension Article: ConvertibleToEntity {
    typealias EntityType = ArticlesEntity

    func toEntity(context: NSManagedObjectContext) -> ArticlesEntity {
        // Implementing conversion logic from Article to ArticlesEntity
        let articlesEntity = ArticlesEntity(context: context)
        articlesEntity.title = self.title
        articlesEntity.descript = self.description
        articlesEntity.imgUrl = self.urlToImage
        articlesEntity.url = self.url

        if let source = source {
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
        // Implementing conversion logic from News to NewsEntity
        let newsEntity = existingEntity(in: context, predicate: nil) ?? NewsEntity(context: context)
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

        let existingEntity = self.existingEntity(in: context, predicate: NSPredicate(format: "title == %@", self.title)) ?? BookmarkEntity(context: context)

        existingEntity.title = self.title
        existingEntity.desc = self.description
        existingEntity.url = self.url
        existingEntity.urlToImage = self.imageURL

        return existingEntity
    }
}


