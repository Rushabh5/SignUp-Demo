//
//  CoreDataManager.swift
//  Demo
//
//  Created by Rushabh Shah on 10/8/19.
//  Copyright © 2019 Rushabh Shah. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

    //MARK: - Properties
    static let shared = CoreDataManager()
    private let persistentContainer = NSPersistentContainer(name: "Demo")
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    private init() {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            print(storeDescription)
            if let err = error as NSError? {
                fatalError("Unresolved error \(err), \(err.userInfo)")
            }
        }
    }
    
    //MARK: User CRUD Methods
    func getUsers(completion: @escaping ((_ allUsers: [User]) -> Void)) {
        var tempUsers = [User]()
        do {
            tempUsers = try viewContext.fetch(User.fetchRequest())
            completion(tempUsers)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
    
    func insertUser(fullName: String, userName: String, email: String, dob: Date, mobileNumber: String, completion: @escaping voidCompletion) {
        if let userEntity = NSEntityDescription.insertNewObject(forEntityName: CoreDataEntity.user.key, into: viewContext) as? User {
            userEntity.fullname = fullName
            userEntity.username = userName
            userEntity.email = email
            userEntity.dob = dob
            userEntity.mobile_number = mobileNumber
        }
        saveContext(completion: completion)
    }
    
    func deleteUser(user: User, completion: voidCompletion?) {
        viewContext.delete(user)
        saveContext(completion: completion)
    }
    
    //MARK: - Context
    func saveContext(completion: (()->Void)? = nil) {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                completion?()
            } catch {
                let err = error as NSError
                print("Unresolved error \(err), \(err.userInfo)")
            }
        }
    }
    
    func deleteAllData(forEntity entity: CoreDataEntity) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.key)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
        saveContext()
    }
    
    
    
}

extension CoreDataManager {
    
    enum CoreDataEntity {
        case user
        
        var key: String {
            switch self {
            case .user: return "User"
            }
        }
    }
    
}
