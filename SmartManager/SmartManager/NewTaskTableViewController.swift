//
//  NewTaskTableViewController.swift
//  SmartManager
//
//  Created by Anton Borisenko on 7/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class NewTaskTableViewController: UITableViewController {

    // variable to pass task to be modified
    var currentTask: Task?
    
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskLocationTextField: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        taskNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) {_ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    func saveTask() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = taskImage.image
        } else {
            image = UIImage(named: "default_task")
        }
        
        let imageData = image?.pngData()
        
        let dateFormatter = DateFormatter()
        let dateTemplate = "yyyy/MM/dd hh:mm"
        let dateLocale = Locale(identifier: "ru")
        let dateFormat =  DateFormatter.dateFormat(fromTemplate: dateTemplate, options: 0, locale: dateLocale)
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from: taskDatePicker.date)
        
        let newTask = Task(name: taskNameTextField.text!,
                           location: taskLocationTextField.text,
                           date: date,
                           imageData: imageData)
        
        if currentTask != nil {
            try! realm.write {
                currentTask?.imageData = newTask.imageData
                currentTask?.name = newTask.name
                currentTask?.location = newTask.location
                currentTask?.date = newTask.date
            }
        } else {
            StorageManager.saveObject(newTask)
        }

    }
    
    private func setupEditScreen() {
        if currentTask != nil {
            setupNavigationBar()
            imageIsChanged = true
            guard let data = currentTask?.imageData, let image = UIImage(data: data) else { return }
            
            taskImage.image = image
            taskImage.contentMode = .scaleAspectFill
            taskNameTextField.text = currentTask?.name
            taskLocationTextField.text = currentTask?.location
            
            let dateFormatter = DateFormatter()
            let dateTemplate = "yyyy/MM/dd hh:mm"
            let dateLocale = Locale(identifier: "ru")
            let dateFormat =  DateFormatter.dateFormat(fromTemplate: dateTemplate, options: 0, locale: dateLocale)
            dateFormatter.dateFormat = dateFormat
            let date = dateFormatter.date(from: currentTask!.date)

            taskDatePicker.date = date!
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentTask?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}

// MARK: - Text field delegate

extension NewTaskTableViewController: UISearchTextFieldDelegate {
    
    // to hide keyboard when tap Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if taskNameTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

// MARK: - Work with image
extension NewTaskTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        taskImage.image = info[.editedImage] as? UIImage
        taskImage.contentMode = .scaleAspectFill
        taskImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
