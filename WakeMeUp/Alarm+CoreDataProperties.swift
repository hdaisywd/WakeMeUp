//
//  Alarm+CoreDataProperties.swift
//  WakeMeUp
//
//  Created by Daisy Hong on 2023/10/04.
//
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var title: String?
    @NSManaged public var time: String?
    @NSManaged public var days: String?
    @NSManaged public var repeating: Bool
    @NSManaged public var isAble: Bool

}

extension Alarm : Identifiable {

}
