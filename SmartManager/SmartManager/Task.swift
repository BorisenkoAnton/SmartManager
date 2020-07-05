//
//  Task.swift
//  SmartManager
//
//  Created by Anton Borisenko on 7/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var date = ""
    @objc dynamic var imageData: Data?
    
    convenience init(name: String, location: String?, date: String, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.date = date
        self.imageData = imageData
    }
}
