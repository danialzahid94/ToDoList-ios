//
//  ToDoDetailsViewController.swift
//  ToDoList
//
//  Created by Danial Zahid on 11/07/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import RealmSwift


class ToDoDetailsViewController: UIViewController, UITextFieldDelegate {
    
    static let segueIdentifier = "showToDoDetailsVC"
    
    var mainTask : Task!
    let realm = try! Realm()

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleField.delegate = self
        descriptionField.delegate = self
        priorityField.delegate = self
        
        if mainTask != nil {
            titleField.text = mainTask.title ?? ""
            descriptionField.text = mainTask.descriptionText ?? ""
            priorityField.text = String(mainTask.priority.value ?? 10)
        }
        else {
            mainTask = Task()
            try! realm.write {
                realm.add(mainTask)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case titleField:
            try! realm.write {
                mainTask.title = titleField.text
            }
        case descriptionField:
            try! realm.write {
                mainTask.descriptionText = descriptionField.text
            }
        case priorityField:
            try! realm.write {
                mainTask.priority.value = Int(priorityField.text ?? "10")
            }
        default:
            break
        }
        
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
