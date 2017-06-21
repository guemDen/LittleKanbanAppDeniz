//
//  User+CoreDataProperties.swift
//  LittleKanban
//
//  Created by admin on 10.06.17.
//  Copyright © 2017 Suraya Shivji. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var email: String?
    @NSManaged public var profilename: String?
    @NSManaged public var password: String?
    @NSManaged public var littleKanbanBoards: NSSet?

}

// MARK: Generated accessors for littleKanbanBoards
extension User {

    @objc(addLittleKanbanBoardsObject:)
    @NSManaged public func addToLittleKanbanBoards(_ value: LittleKanbanBoard)

    @objc(removeLittleKanbanBoardsObject:)
    @NSManaged public func removeFromLittleKanbanBoards(_ value: LittleKanbanBoard)

    @objc(addLittleKanbanBoards:)
    @NSManaged public func addToLittleKanbanBoards(_ values: NSSet)

    @objc(removeLittleKanbanBoards:)
    @NSManaged public func removeFromLittleKanbanBoards(_ values: NSSet)

}
