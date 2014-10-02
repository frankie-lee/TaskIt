//
//  TaskModel.swift
//  TaskIt
//
//  Created by Frank Lee on 2014-09-30.
//  Copyright (c) 2014 franklee. All rights reserved.
//

import Foundation
import CoreData

class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}
