//
//  TaskModel.swift
//  SmartManager
//
//  Created by Anton Borisenko on 7/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

struct Task {
    
    var name: String
    var location: String
    var date: String
    var image: String?
    
    // temp array for testing during developong
    static let tempArray = ["task1", "task2", "task3", "task4", "task5", "task6", "task7", "task8", ]
    
    static func getTasks() -> [Task] {
        
        var tasks = [Task]()
        
        for taskname in tempArray {
            tasks.append(Task(name: taskname, location: "Wery Horuzhey 18/1", date: "04.07.2020 18:00", image: "default_task"))
        }
        return tasks
    }
}
