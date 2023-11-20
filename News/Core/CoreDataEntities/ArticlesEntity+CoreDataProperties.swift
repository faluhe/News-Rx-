//
//  ArticlesEntity+CoreDataProperties.swift
//  News
//
//  Created by Ismailov Farrukh on 07/09/23.
//
//

import Foundation
import CoreData


extension ArticlesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticlesEntity> {
        return NSFetchRequest<ArticlesEntity>(entityName: "ArticlesEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var url: String?
    @NSManaged public var imgUrl: String?
    @NSManaged public var descript: String?
    @NSManaged public var content: String?
    @NSManaged public var author: String?
    @NSManaged public var source: SourcesEntity?

}

extension ArticlesEntity : Identifiable {

}
