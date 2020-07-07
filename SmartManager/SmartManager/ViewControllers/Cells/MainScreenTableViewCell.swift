//
//  MainScreenTableViewCell.swift
//  SmartManager
//
//  Created by Anton Borisenko on 7/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import Cosmos

class MainScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImage: UIImageView! {
        didSet {
            // to make image view to be circle
            taskImage.layer.cornerRadius = taskImage.frame.size.height / 2
            taskImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskLocationLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    
}
