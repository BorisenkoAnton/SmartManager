//
//  ViewController.swift
//  SmartManager
//
//  Created by Anton Borisenko on 6/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class MainScreenTableViewController: UITableViewController {

    let tempArray = [
        "task1", "task2", "task3", "task4", "task5", "task6", "task7", "task8"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        cell.textLabel?.text = tempArray[indexPath.row]
        cell.imageView?.image = UIImage(named: "default_task")
        
        // to make image view to be circle
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
