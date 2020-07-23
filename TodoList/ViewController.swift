//
//  ViewController.swift
//  TodoList
//
//  Created by Joshua Abbott on 6/25/20.
//  Copyright © 2020 Joshua Abbott. All rights reserved.
//

import UIKit
import UserNotifications

// Global variables:
let notifCenter = UNUserNotificationCenter.current()
struct Task {
    var title: String
    var description: String
    var completed: Bool
    var scheduledDate: Date
    var remindDate: Date
    var remindId: String
}

// Global functions:
func stringToDate(strDate: String) -> Date {
    let dateFormatter = DateFormatter();
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    
    return dateFormatter.date(from: strDate)!
}
func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter();
    dateFormatter.dateFormat = "MM/dd/yyy"
    
    return dateFormatter.string(from: date)
}
func createNotification(taskTitle: String, dueDate: Date, remindDate: Date) -> String {
    // 2. create the notification content
    let content = UNMutableNotificationContent()
    content.title = "Upcoming Task: " + taskTitle
    content.body = "Your task \"" + taskTitle + "\" is due " + dateToString(date: dueDate)
    
    // 3. create notification trigger
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: remindDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    // 4. create a request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    
    // 5. register with notification center
    notifCenter.add(request) { (error) in
        // Potential todo: check the error parameter and handle any errors
    }
    
    return uuidString
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditProtocol, AddProtocol {
    
    var tasks: [Task] = []
    let dateFormatter = DateFormatter();
    var editTaskIndex: Int!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chkShowComplete: UISwitch!
    
    // Called when view loads:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Todo List"
        
        // 1. ask user for notification permisions:
        notifCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Potential todo: add code telling them how to enable later
        }
    }
    
    // Called when user taps chkShowComplete slider:
    @IBAction func chkShowCompleteChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    // Gets some things ready before moving to the next ViewController:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Then catch the index of task being edited:
        editTaskIndex = tableView.indexPathForSelectedRow?.row
        
        if (segue.identifier == "addSegue") {
            let view = segue.destination as! AddViewController
            view.delegate = self
        }
        if (segue.identifier == "editSegue") {
            let view = segue.destination as! EditViewController
            view.delegate = self
            let editView = segue.destination as? EditViewController
            
            // Set the selectedTask properties in the EditViewController
            editView?.selectedTask.title = tasks[editTaskIndex].title
            editView?.selectedTask.description = tasks[editTaskIndex].description
            editView?.selectedTask.completed = tasks[editTaskIndex].completed
            editView?.selectedTask.scheduledDate = tasks[editTaskIndex].scheduledDate
            editView?.selectedTask.remindDate = tasks[editTaskIndex].remindDate
            editView?.selectedTask.remindId = tasks[editTaskIndex].remindId
            
        }
    }
    
    // This is called by the AddViewController delegate:
    func setResultOfAddTask(task: Task) {
        // Get the new values from the AddViewController:
        let newTask = Task(title: task.title, description: task.description, completed: task.completed, scheduledDate: task.scheduledDate, remindDate: task.remindDate, remindId: task.remindId)
        
        // Add them to the list of items:
        tasks.append(newTask)
        
        // Reload the list:
        self.tableView.reloadData()
    }
    
    // This is called by the EditViewController delegate:
    func setResultOfEditTask(task: Task) {
        // Update the values of the selected node:
        tasks[editTaskIndex].title = task.title
        tasks[editTaskIndex].description = task.description
        tasks[editTaskIndex].completed = task.completed
        tasks[editTaskIndex].scheduledDate = task.scheduledDate
        tasks[editTaskIndex].remindDate = task.remindDate
        tasks[editTaskIndex].remindId = task.remindId
        
        // Reload the list:
        self.tableView.reloadData()
    }
    
    // Table View Methods-----------------------------------------------------
    // Called once at table initialization:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chkShowComplete.isOn {
            return tasks.count
        } else {
            let incompleteTasks = tasks.lazy.filter{ c in c.completed == false }
            return incompleteTasks.count
        }
    }
    
    // Called for each cell:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get (and possibly recycle) the cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CheckTableViewCell
        
        var theseTasks: [Task] = []
        
        if chkShowComplete.isOn {
            theseTasks = tasks
        } else {
            theseTasks = tasks.lazy.filter{ c in c.completed == false }
        }
        
        // Set the cell's properties
        cell.lblTitle.text = theseTasks[indexPath.row].title
        cell.lblDate.text = dateToString(date: theseTasks[indexPath.row].scheduledDate)
        cell.btnCheck.isSelected = theseTasks[indexPath.row].completed
        
        // Attach checkbox listener
        if let btnChk = cell.btnCheck{
            btnChk.tag = indexPath.row
            btnChk.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
        }
        
        return cell
    }

    // Called when cell is tapped/selected:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Deselects the cell after returning
    }
    
    // This is called when a row is swiped right to left
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .destructive, title: "Delete") { (action: UIContextualAction, sourceView: UIView, actionPerformed: (Bool) -> Void) in
            
            // Remove the item at the given index:
            self.tasks.remove(at: indexPath.row)
            
            // Reload the list:
            self.tableView.reloadData()
            
            actionPerformed(true)
        }
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    // End Table View Methods-------------------------------------------------
    
    // Toggles the cell's checkbox:
    @objc func checkboxClicked(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        tasks[sender.tag].completed = sender.isSelected
        
        // Toggle notifications:
        if tasks[sender.tag].completed {
            // 6. Remove old notification
            notifCenter.removePendingNotificationRequests(withIdentifiers: [tasks[sender.tag].remindId])
        } else {
            // Add the notification again
            let uuidString = createNotification(taskTitle: tasks[sender.tag].title, dueDate: tasks[sender.tag].scheduledDate, remindDate: tasks[sender.tag].remindDate)
            tasks[sender.tag].remindId = uuidString
        }
        
        // Reload the list:
        self.tableView.reloadData()
    }
}
