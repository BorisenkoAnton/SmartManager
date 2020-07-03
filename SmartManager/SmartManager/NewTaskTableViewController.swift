//
//  NewTaskTableViewController.swift
//  SmartManager
//
//  Created by Anton Borisenko on 7/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class NewTaskTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }
    
}

// MARK: - Text field delegate

extension NewTaskTableViewController: UISearchTextFieldDelegate {
    
    // to hide keyboard when tap Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
