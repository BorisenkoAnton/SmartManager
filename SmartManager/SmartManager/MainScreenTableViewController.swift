//
//  ViewController.swift
//  SmartManager
//
//  Created by Anton Borisenko on 6/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class MainScreenTableViewController: UITableViewController {

    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
    
    let tasks = Task.getTasks()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! MainScreenTableViewCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].name
        cell.taskLocationLabel.text = tasks[indexPath.row].location
        cell.taskDateLabel.text = tasks[indexPath.row].date
        cell.taskImage.image = UIImage(named: tasks[indexPath.row].image ?? "default_task")
        
        // to make image view to be circle
        cell.taskImage.layer.cornerRadius = cell.taskImage.frame.size.height / 2
        cell.taskImage.clipsToBounds = true
        
        return cell
    }
    
}
