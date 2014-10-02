//
//  TaskCell.swift
//  TaskIt
//
//  Created by Frank Lee on 2014-09-25.
//  Copyright (c) 2014 franklee. All rights reserved.
//

import Foundation
import UIKit

//inherits from UITableViewCell (add our own functionality after inheriting)
class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
