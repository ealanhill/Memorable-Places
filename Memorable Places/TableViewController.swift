//
//  TableViewController.swift
//  Memorable Places
//
//  Created by E Alan Hill on 3/22/16.
//  Copyright © 2016 619 Fitness. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController {
    
    var locations = [MemorablePlace]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locations)
        
        if let locations = NSUserDefaults.standardUserDefaults().objectForKey("memorablePlaces") as? NSData {
            self.locations = NSKeyedUnarchiver.unarchiveObjectWithData(locations) as! [MemorablePlace]
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("reloading table")
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func addLocation(locationToAdd: MemorablePlace) {
        print("Received location: \(locationToAdd)")
        if !locations.contains(locationToAdd) {
            locations.append(locationToAdd)
        }
        print("locations: \(locations)")
        
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self.locations), forKey: "memorablePlaces")
    }
    
    @IBAction func clearLocations(sender: AnyObject) {
        self.locations.removeAll()
        tableView.reloadData()
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self.locations), forKey: "memorablePlaces")
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 90)
    }
    
    // defines contents of each individual cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("defining cell content")
        
        let cellIdentifier = "MemorablePlaceTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemorablePlaceTableViewCell
        
        let location = locations[indexPath.row]
        
        print("Location: \(location)")
        cell.addressLabel.text = location.address
        cell.nameLabel.text = location.title
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When preparing for the segue, have viewController1 provide a closure for
        // onDataAvailable
        if let viewController = segue.destinationViewController as? ViewController {
            viewController.onLocationAvailable = {[weak self]
                (location) in
                if let weakSelf = self {
                    weakSelf.addLocation(location)
                }
            }
        }
    }
}