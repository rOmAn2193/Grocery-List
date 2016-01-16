//
//  MainTVC.swift
//  Grocery List
//
//  Created by Roman on 1/15/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//

import UIKit
import CoreData

class MainTVC: UITableViewController, NSFetchedResultsControllerDelegate
{

    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var frc : NSFetchedResultsController = NSFetchedResultsController()

    func fetchRequest() -> NSFetchRequest
    {
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    func getFRC() -> NSFetchedResultsController
    {
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        frc = getFRC()
        frc.delegate = self

        do
        {
            try frc.performFetch()
        }
        catch
        {
            print("Failed to perform initial fetch.")
            return
        }

        self.tableView.rowHeight = 60
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "orange-bg"))
        self.tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool)
    {
        frc = getFRC()
        frc.delegate = self

        do
        {
            try frc.performFetch()
        }
        catch
        {
            print("Failed to perform initial fetch.")
            return
        }

        self.tableView.reloadData()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        let numberOfRowsInSection = frc.sections?.count

        return numberOfRowsInSection!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let numberOfRowsInSection = frc.sections?[section].numberOfObjects

        return numberOfRowsInSection!
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor.clearColor()
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.detailTextLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }

        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.detailTextLabel?.textColor = UIColor.grayColor()

        let item = frc.objectAtIndexPath(indexPath) as! Item
        cell.textLabel?.text = item.name
        let note = item.note
        let qty = item.qty
        cell.detailTextLabel!.text = "Qty: \(qty!) Note: \(note!)"
        cell.imageView?.image = UIImage(data: (item.image)!)

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let managedObject : NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
        moc.deleteObject(managedObject)

        do
        {
            try moc.save()
        }
        catch
        {
            print("Failed to save.")
            return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
        tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "edit"
        {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let itemController : AddEditVC = segue.destinationViewController as! AddEditVC
            let item : Item = frc.objectAtIndexPath(indexPath!) as! Item
            itemController.item = item
        }
    }


}
