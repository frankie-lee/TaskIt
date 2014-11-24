//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Frank Lee on 2014-09-29.
//  Copyright (c) 2014 franklee. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //completion block - when animation done, run code? no (then nil)
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //UIApplication represents our whole application. Only one instance of UIApplication. 
    //sharedApplication returns one instance (impossible to return more than one)
    //Gives access to our appdelegate.
    @IBAction func addTaskButtonTapped(sender: UIButton) {
        
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        
        //just accessing managedObjectContext from appDelegate.
        let managedObjectContext = appDelegate.managedObjectContext
        
        //NSentityDescription, maps entity to persistance store. Needed to create TaskModel.
        
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        
        //allows entity to enter persistance store, now you have entity you can set properties for.
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        task.task = taskTextField.text
        task.subtask = subtaskTextField.text
        task.date = dueDatePicker.date
        task.completed = false
        
        appDelegate.saveContext() //SAVES any changes we've made to our entity.
        
        //how to get all instances of entities I've created
        //NSFetchRequest: I want to request all instances of TaskModel
        var request = NSFetchRequest (entityName: "TaskModel")
        var error:NSError? = nil  //create NSError instance, initial value = nil. Mandatory. Will be printed if there's an error writing to   Coredata.
                                  //value is only assigned if there is an error. Write error memory address.
        
        //Array type NSArray. Must unwrap (!) because it could be nil. Pass in our request (NSFetchRequest, access instances of our entity)
        var results: NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
        
        //results is an array (must iterate through all instances that were pulled with NSFetchRequest.
        for res in results {
            println(res)
        }
        
        //remove current ViewController and present the main ViewController on the screen.
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
