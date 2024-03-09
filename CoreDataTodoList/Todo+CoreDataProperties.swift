//
//  Todo+CoreDataProperties.swift
//  CoreDataTodoList
//
//  Created by Gaspar Dolcemascolo on 09/03/2024.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var done: Bool
    @NSManaged public var id: UUID?

}

extension Todo : Identifiable {

}
