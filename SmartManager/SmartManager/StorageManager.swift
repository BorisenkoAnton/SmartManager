//
//  StorageManager.swift
//  SmartManager
//
//  Created by Anton Borisenko on 7/5/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ task: Task) {
        
        try! realm.write {
            realm.add(task)
        }
    }
    
    static func deleteObject(_ task: Task) {
        
        try! realm.write {
            realm.delete(task)
        }
    }
}
