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
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locations)
        
        if let locations = NSUserDefaults.standardUserDefaults().objectForKey("memorablePlaces") as? NSData {
            self.locations = NSKeyedUnarchiver.unarchiveObjectWithData(locations) as! [MemorablePlace]
        }
        
        if self.locations.count == 0 {
            locations.append(MemorablePlace(name: "Sample Memorable Place Title", address: "Sample Address", latitude: 0, longitude: 0)!)
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
        if self.locations.count == 1 && self.locations[0].title == "Sample Memorable Place Title" {
            self.locations.removeAll()
        }
        
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
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.selectedRow = indexPath.row
        
        return indexPath
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
            
            if selectedRow != -1 {
                print("Selected Row: \(selectedRow)")
                viewController.setMemorablePlace(locations[selectedRow])
            }
        }
    }
}