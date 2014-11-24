//
//  ViewController.swift
//  TaskIt
//
//  Created by Frank Lee on 2014-09-25.
//  Copyright (c) 2014 franklee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //have this constant to make changes to entities VIA managedObjectContext, same as code in addtask for addTaskViewController
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    //Making an instance (optimized way to manage updating our tableview with changes to our entities)
    var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //delegates send messages to you.
        //ex: accelerometer delegate sends messages about accelerometer.
        //It sends messages to the fetchedResultsController in this case (designated by .delegate)
        //fetchedResultsController is where you want the message to go.
        //fetchedResultsController.delegate = self, sends the messages to YOU.
        
        fetchedResultsController = getFetchedResultsController() //fetchedResults = data pulled from entity
        fetchedResultsController.delegate = self //this viewcontroller instance (can call functions in self)
        fetchedResultsController.performFetch(nil) //tell fetch results controller to start monitoring changes (grab initial batch of entities)
    }
    
    //occurs everytime this viewcontroller is presented on screen. Refresh all the info in our table view.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //passes values in the segue from one view controller to the next
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
            detailVC.detailTaskModel = thisTask
        }
        else if segue.identifier == "showTaskAdd" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as AddTaskViewController
        }
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    //UITableViewDataSouce
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count //counts number of sections via fetchedResultsController = NSFetchResultsController()
    }
    
    //section number (section 0 is the first array).
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects //returns number of rows in a section
    }
    
    //passing in tableview parameter: ie. tableView.deque... etc.
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //creates reusable tableView cell, using "myCell" of type TaskCell (type cast)
        var cell:TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel //specify TaskModel instance
        
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        
        return cell
    }
    
    //This is for UITableViewDelegate, optional.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if fetchedResultsController.sections?.count == 1 {
            let fetchedObjects = fetchedResultsController.fetchedObjects!
            
            let testTask:TaskModel = fetchedObjects[0] as TaskModel
            
            if testTask.completed == true {
                return "Completed"
            }
            else {
                return "To do"
            }
        }
            
        else {
            if section == 0 {
                return "To Do"
            }
            else {
                return "Completed"
            }
        }
    }
    
    //when swiped
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel //returns the object at index path
        
        if thisTask.completed == true {
            thisTask.completed = false
        } else {
            thisTask.completed = true
        }
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext() //save whatever changes made to entity
    }
    
    //NSFetchedResultsControllerDelegate
    //called automatically when changes are made to entities (update information in TableView)
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    //Helper
    
    //request returns NSFetchRequest instance
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName:"TaskModel") //grabbing entity instance
        let sortDescriptor = NSSortDescriptor(key:"date", ascending: true) //using date as the key sort
        let completedDescriptor = NSSortDescriptor(key:"completed", ascending: true)
        
        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor] //allows multiple sort descriptors
        
        return fetchRequest //return this request
    }
    
    //pass in fetch request
    
    //get fetchrequest from taskFetchRequest, managedobjectContext
    //pass in taskFetchRequest (of sorted by date entities).
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchedResultsController
    }
    
}

