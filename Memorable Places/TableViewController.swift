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
    
    var locations = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locations)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func addLocation(locationToAdd: CLLocation) {
        print("Received location: \(locationToAdd)")
        locations.append(locationToAdd)
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