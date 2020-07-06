//
//  ViewController.swift
//  SmartManager
//
//  Created by Anton Borisenko on 6/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

class MainScreenTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    var tasks: Results<Task>!
    var ascendingSorting = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = realm.objects(Task.self)
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.isEmpty ? 0 : tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell {
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

    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let task = tasks[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            
            StorageManager.deleteObject(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let task = tasks[indexPath.row]
            let newTaskVC = segue.destination as! NewTaskTableViewController
            newTaskVC.currentTask = task
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {

        guard let newTaskVC = segue.source as? NewTaskTableViewController else { return }
        
        newTaskVC.saveTask()
        tableView.reloadData()
    }

    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            tasks = tasks.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            tasks = tasks.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
}
