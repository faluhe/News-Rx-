//
//  SourcesEntity+CoreDataProperties.swift
//  News
//
//  Created by Ismailov Farrukh on 07/09/23.
//
//

import Foundation
import CoreData


extension SourcesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourcesEntity> {
        return NSFetchRequest<SourcesEntity>(entityName: "SourcesEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}

extension SourcesEntity : Identifiable {

}
