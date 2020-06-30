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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tasks: [Task] = []
    let dateFormatter = DateFormatter();
    dateFormatter.dateStyle = .short
    //dateFormatter.timeStyle = .none
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Todo List"
        let arbitraryDate = dateFormatter.date(from: "07/10/2020 22:31")
        
        // Hardcode task for now:
        tasks.append(Task(title: "Task 1", description: "This is task 1", completed: true, scheduledDate: dateFormatter.date(from: "10/07/2020")!, remindDate: dateFormatter.date(from: "07/10/2020")!))
    }
    
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
        cell.lblDate.text = dateFormatter.string(from: tasks[indexPath.row].scheduledDate)
        cell.btnCheck.isSelected = tasks[indexPath.row].completed
        
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
}

