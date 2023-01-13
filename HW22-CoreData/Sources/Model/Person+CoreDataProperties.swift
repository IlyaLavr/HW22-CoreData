//
//  Person+CoreDataProperties.swift
//  HW22-CoreData
//
//  Created by Илья on 13.01.2023.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var image: Data?
    @NSManaged public var addDate: Date?

}

extension Person : Identifiable {

}
