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

class EditViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var chkComplete: UISwitch!
    @IBOutlet weak var dpScheduled: UIDatePicker!
    @IBOutlet weak var dpReminder: UIDatePicker!
    
    var selectedTask = Task(title: "", description: "", completed: false, scheduledDate: Date(), remindDate: Date(), remindId: "")
    // This delegate is used to communicated between this file and ViewController.swift
    var delegate: EditProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Task" // Sets the title in the navigation bar
        txtDescription.delegate = self // Used for manual placeholder text
        
        // Creates a navigation bar item linked to a "saveItem" method:
        let save = UIBarButtonItem(barButtonSystemItem: .save,
        target: self, action: #selector(saveItem))
        self.navigationItem.rightBarButtonItem = save
    }
    
    // Sets the UI inputs to the task's properties
    override func viewWillAppear(_ animated: Bool) {
        txtTitle.text = selectedTask.title
        txtDescription.text = selectedTask.description
        chkComplete.isOn = selectedTask.completed
        dpScheduled.date = selectedTask.scheduledDate
        dpReminder.date = selectedTask.remindDate
        
        // More ridiculous manual placeholder management
        if(txtDescription.text != "Task Description") {
            txtDescription.textColor = UIColor.black
        }
    }
    
    // This method is triggered when a user clicks save:
    @objc func saveItem() {
        // Edit notification
        let uuidString = createNotification(taskTitle: txtTitle.text!, dueDate: dpScheduled.date, remindDate: dpReminder.date)

        // 6. Remove old notification
        notifCenter.removePendingNotificationRequests(withIdentifiers: [selectedTask.remindId])
        
        // Calls back to ViewController with my data using the method specified in AddProtocol. That method will add a new item.
        if(txtTitle.text != nil) {
            delegate?.setResultOfEditTask(task: Task(title: txtTitle.text!, description: txtDescription.text!, completed: chkComplete.isOn, scheduledDate: dpScheduled.date, remindDate: dpReminder.date, remindId: uuidString))
            self.navigationController?.popViewController(animated: true)
        }
    }

    // This is triggered when the user selectes the UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.opaqueSeparator {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // This is triggered when the user clears the UITextView and leaves it
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Task Description"
            textView.textColor = UIColor.lightGray
        }
    }
}
