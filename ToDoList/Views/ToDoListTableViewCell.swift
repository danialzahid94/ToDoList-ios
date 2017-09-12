//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by Danial Zahid on 11/07/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell {

    static let identifier = "toDoListTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completionButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
