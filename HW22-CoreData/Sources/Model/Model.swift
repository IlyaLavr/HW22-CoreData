//
//  Model.swift
//  HW22-CoreData
//
//  Created by Илья on 13.01.2023.
//

import UIKit
import CoreData

class ModelData {
    var persons: [Person] = []
    
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    private var managedObject: Person {
        Person(context: context)
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                print("Save \(context)")
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getPersons() -> [Person] {
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        let sort = NSSortDescriptor(key: #keyPath(Person.addDate), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            persons = try context.fetch(fetchRequest)
        } catch {
            print("Cannot fetch Expenses")
        }
        return persons
    }
    
    func addPerson(name: String) {
        managedObject.name = name
        saveContext()
    }
    
    func deletePerson(person: Person) {
        context.delete(person)
        saveContext()
    }
}
