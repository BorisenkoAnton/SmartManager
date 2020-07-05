//
//  ViewController.swift
//  SmartManager
//
//  Created by Anton Borisenko on 6/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

class MainScreenTableViewController: UITableViewController {
    
    var tasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = realm.objects(Task.self)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.isEmpty ? 0 : tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! MainScreenTableViewCell

        let task = tasks[indexPath.row]

        cell.taskNameLabel.text = task.name
        cell.taskLocationLabel.text = task.location
        cell.taskDateLabel.text = task.date
        cell.taskImage.image = UIImage(data: task.imageData!)

        // to make image view to be circle
        cell.taskImage.layer.cornerRadius = cell.taskImage.frame.size.height / 2
        cell.taskImage.clipsToBounds = true

        return cell
    }

    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let task = tasks[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            
            StorageManager.deleteObject(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {

        guard let newTaskVC = segue.source as? NewTaskTableViewController else { return }
        
        newTaskVC.saveNewTask()
        tableView.reloadData()
    }

}
