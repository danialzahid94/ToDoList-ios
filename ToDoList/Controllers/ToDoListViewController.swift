//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Danial Zahid on 11/07/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var tasks : Results<Task>!
    let realm = try! Realm()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tasks = realm.objects(Task.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tasks = realm.objects(Task.self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = "Tasks"
        
//        tasks = realm.objects(Task.self)
        
        if let tabBarIndex = self.tabBarController?.selectedIndex {
            switch tabBarIndex {
            case 0:
                title = "Pending Tasks"
                tasks = self.realm.objects(Task.self).filter("completed == 0")
                self.tableView.reloadData()
            case 1:
                title = "Completed Tasks"
                tasks = self.realm.objects(Task.self).filter("completed == 1")
                self.tableView.reloadData()
                self.navigationItem.rightBarButtonItem = nil
            default: break
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions

    @IBAction func sortButtonPressed(_ sender: Any) {
        UIAlertController.showActionSheet(in: self, withTitle: "Sort", message: "Select the paramater to sort by", cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["By Priority","By Date"], popoverPresentationControllerBlock: nil) { (alertController, action, buttonIndex) in
            guard let tabBarIndex = self.tabBarController?.selectedIndex else { return }
            if action.title == "By Priority" {
                self.tasks = self.realm.objects(Task.self).filter("completed == \(tabBarIndex)").sorted(byKeyPath: "priority")
                self.tableView.reloadData()
            }
            else if action.title == "By Date" {
                self.tasks = self.realm.objects(Task.self).filter("completed == \(tabBarIndex)").sorted(byKeyPath: "createdAt")
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func newButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: ToDoDetailsViewController.segueIdentifier, sender: nil)
    }
    
    @IBAction func completionButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        try! realm.write {
            tasks[button.tag].completed = !button.isSelected
        }
        tableView.reloadData()
    }
    //MARK: - Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.identifier, for: indexPath) as! ToDoListTableViewCell
        
        let task = tasks[indexPath.row]
        
        cell.titleLabel.text = task.title ?? ""
        cell.priorityLabel.text = "\(task.priority.value ?? 10)"
        cell.descriptionLabel.text = task.descriptionText ?? ""
        cell.dateLabel.text = UtilityManager.stringFromNSDateWithFormat(date: task.createdAt as NSDate , format: Constant.appDateFormat)
        cell.completionButton.isSelected = task.completed
        cell.completionButton.tag = indexPath.row
        cell.completionButton.addTarget(self, action: #selector(ToDoListViewController.completionButtonPressed), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ToDoDetailsViewController.segueIdentifier, sender: tasks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            try! realm.write {
                realm.delete(tasks[indexPath.row])
            }
            tableView.reloadData()
        }
    }
    
    //MARK: SearchBar delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            tasks = realm.objects(Task.self).filter("title contains '\(searchText)'")
            tableView.reloadData()
        }
        else{
            tasks = realm.objects(Task.self)
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tasks = realm.objects(Task.self)
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ToDoDetailsViewController.segueIdentifier {
            let vc = segue.destination as! ToDoDetailsViewController
            vc.mainTask = sender as? Task

        }
    }
    
    
}
