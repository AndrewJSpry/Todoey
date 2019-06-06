//
//  ViewController.swift
//  Todoey
//
//  Created by Andrew Spry on 6/5/19.
//  Copyright © 2019 Andrew Spry. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
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
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add items to list
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text!.count > 0 {
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done  = false
                self.itemArray.append(newItem)
                self.saveItems()
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
    
    //MARK - Model Data Persistent Storage
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context - \(error)")
        }
    }
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context - \(error)")
        }
    }
    
}

