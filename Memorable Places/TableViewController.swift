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
        locations.append(locationToAdd)
    }
}