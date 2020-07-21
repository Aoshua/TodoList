//
//  EditViewController.swift
//  TodoList
//
//  Created by Joshua Abbott on 6/25/20.
//  Copyright © 2020 Joshua Abbott. All rights reserved.
//

import UIKit

// This protocol assists in passing values to ViewController.swift
protocol EditProtocol {
    func setResultOfEditTask(task: Task)
}

class EditViewController: UIViewController {
    
    var selectedTask = Task(title: "", description: "", completed: false, scheduledDate: Date(), remindDate: Date())
    // This delegate is used to communicated between this file and ViewController.swift
    var delegate: EditProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title in the navigation bar:
        self.title = "Edit Task"
        
        // Creates a navigation bar item linked to a "saveItem" method:
        let save = UIBarButtonItem(barButtonSystemItem: .save,
        target: self, action: #selector(saveItem))
        self.navigationItem.rightBarButtonItem = save
    }
    
    // This method is triggered when a user clicks save:
    @objc func saveItem() {
        // Calls back to ViewController with my data using the method specified in AddProtocol. That method will add a new item.
        if(txtShort.text != nil && txtLong.text != nil) {
            delegate?.setResultOfEditTask(task: Task(title: "", description: "", completed: false, scheduledDate: Date(), remindDate: Date()))
            self.navigationController?.popViewController(animated: true)
        }
    }

}
