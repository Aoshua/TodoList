//
//  AddViewController.swift
//  TodoList
//
//  Created by Joshua Abbott on 6/25/20.
//  Copyright © 2020 Joshua Abbott. All rights reserved.
//

import UIKit

// This protocol assists in passing values to ViewController.swift
protocol AddProtocol {
    func setResultOfAddTask(task: Task)
}

class AddViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var chkComplete: UISwitch!
    @IBOutlet weak var dpScheduled: UIDatePicker!
    @IBOutlet weak var dpReminder: UIDatePicker!
    
    // This delegate is used to communicated between this file and ViewController.swift
    var delegate: AddProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Task" // Sets the title in the navbar
        txtDescription.delegate = self // Used for manual placeholder text
        
        // Creates a navigation bar button linked to a "saveItem" method:
        let save = UIBarButtonItem(barButtonSystemItem: .save,
        target: self, action: #selector(saveItem))
        self.navigationItem.rightBarButtonItem = save
        
        // This allows the user to click anywhere to close the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    // This method is triggered when a user clicks save:
    @objc func saveItem() {
        // Set up notification:
        let uuidString = createNotification(taskTitle: txtTitle.text!, dueDate: dpScheduled.date, remindDate: dpReminder.date)
        
        // Calls back to ViewController with my data using the method specified in AddProtocol. That method will add a new item.
        if(txtTitle.text != nil) {
            delegate?.setResultOfAddTask(task: Task(title: txtTitle.text!, description: txtDescription.text!, completed: chkComplete.isOn, scheduledDate: dpScheduled.date, remindDate: dpReminder.date, remindId: uuidString))
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
