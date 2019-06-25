//
//  ViewController.swift
//  Todoey
//
//  Created by Andrew Spry on 6/5/19.
//  Copyright © 2019 Andrew Spry. All rights reserved.
//

import UIKit
import RealmSwift

///////////////////////////////////////////
//MARK: To Do List View Controller
class ToDoListViewController : SwipeTableViewController {
    
    let realm = try! Realm()

    var items : Results<Item>?
    
    var selectedCategory : Category? {
        didSet { loadItems() }
    }

    @IBOutlet weak var searchButton: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65.0
        searchButton.delegate = self
    }

    //MARK: - Tableview Data Source Methods.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType   = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items"
        }
        return cell
    }
    
    //MARK: - Delete ToDo Item Methods.
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.items?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting Item \(error)")
            }
        }
    }

    //MARK: - Tableview Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Cannot saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add ToDo Item.  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("Error saving items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField

        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Data Persistent Storage
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}


///////////////////////////////////////////
//MARK: UISearchBar Methods
extension ToDoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

