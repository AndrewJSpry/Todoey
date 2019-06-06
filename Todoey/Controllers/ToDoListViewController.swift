//
//  ViewController.swift
//  Todoey
//
//  Created by Andrew Spry on 6/5/19.
//  Copyright © 2019 Andrew Spry. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Import saved ToDo List.
        if let items = defaults.array(forKey: "ToDoListArray") as? [Items] {
            itemArray = items
        }

        //        // Initialize test data items.
        //        let newItem1 = Item()
        //        newItem1.title = "Find Mike"
        //        itemArray.append(newItem1)
        //        let newItem2 = Item()
        //        newItem2.title = "Buy Eggos"
        //        itemArray.append(newItem2)
        //        let newItem3 = Item()
        //        newItem3.title = "Destroy Demogorgon"
        //        itemArray.append(newItem3)

    }

    //MARK - Tableview Data Source Methods.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel!.text = item.title
        cell.accessoryType   = item.done ? .checkmark : .none
        return cell;
    }

    //MARK - Tableview Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done.toggle()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add items to list
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text!.count > 0 {
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

