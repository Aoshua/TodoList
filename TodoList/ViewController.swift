//
//  ViewController.swift
//  TodoList
//
//  Created by Joshua Abbott on 6/25/20.
//  Copyright © 2020 Joshua Abbott. All rights reserved.
//

import UIKit

struct Task {
    var title: String
    var description: String
    var completed: Bool
    var scheduledDate: Date
    var remindDate: Date
}

func stringToDate(strDate: String) -> Date {
    let dateFormatter = DateFormatter();
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    
    return dateFormatter.date(from: strDate)!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tasks: [Task] = []
    let dateFormatter = DateFormatter();
    var editTaskIndex: Int!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Todo List"
        
        // Hardcode task for now:
        tasks.append(Task(title: "Task 1", description: "This is task 1", completed: false, scheduledDate: stringToDate(strDate: "10/07/2020"), remindDate: stringToDate(strDate: "07/10/2020")))

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
            editView?.selectedTask.remindDate = tasks[editTaskIndex].remindDate
            editView?.selectedTask.scheduledDate = tasks[editTaskIndex].scheduledDate
            
        }
    }
    
    // This is called by the EditViewController delegate:
    func setResultOfEditTask(task: Task) {
        // Update the values of the selected node:
        tasks[editTaskIndex].title = task.title
        tasks[editTaskIndex].description = task.description
        tasks[editTaskIndex].completed = task.completed
        tasks[editTaskIndex].scheduledDate = task.scheduledDate
        tasks[editTaskIndex].remindDate = task.remindDate
        
        // Reload the list:
        self.tableView.reloadData()
    }
    
    // Table View Methods-----------------------------------------------------
    // Called once at table initialization:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Called for each cell:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get (and possibly recycle) the cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CheckTableViewCell
        
        // Set the cell's properties
        cell.lblTitle.text = tasks[indexPath.row].title
        //let thing1 = tasks[indexPath.row].scheduledDate
        //let thing2 = dateFormatter.string(from: thing1)
        cell.lblDate.text = "12/19/2020" //dateFormatter.string(from: tasks[indexPath.row].scheduledDate)
        cell.btnCheck.isSelected = tasks[indexPath.row].completed
        
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
            //self.items.remove(at: indexPath.row)
            
            // Reload the list:
            //self.tableView.reloadData()
            
            actionPerformed(true)
        }
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    // End Table View Methods-------------------------------------------------
    
    // Toggles the cell's checkbox:
    @objc func checkboxClicked(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        tasks[sender.tag].completed = sender.isSelected
    }
}

