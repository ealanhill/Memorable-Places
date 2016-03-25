//
//  ViewController.swift
//  Memorable Places
//
//  Created by E Alan Hill on 3/11/16.
//  Copyright © 2016 619 Fitness. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var onLocationAvailable : ((location: MemorablePlace) -> ())?
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up our location manager
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            let center = locationManager.location?.coordinate
            let region:MKCoordinateRegion = MKCoordinateRegionMake(center!, MKCoordinateSpanMake(0.1, 0.1))
            
            self.map.setRegion(region, animated: false)
        }
        // long press
        let uilpgr = UILongPressGestureRecognizer(target: self, action:  #selector(ViewController.longPress(_:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPress(gestureRecognizer: UIGestureRecognizer) {
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            let touchPoint = gestureRecognizer.locationInView(self.map)
            
            let center: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let latDelta:CLLocationDegrees = 0.1
            let longDelta:CLLocationDegrees = 0.1
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span)
            
            self.map.setRegion(region, animated: true)
            
            self.getSelectedLocation(CLLocation(latitude: center.latitude, longitude: center.longitude))
        }
        
        
    }
    
    func getSelectedLocation(location: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if(error != nil) {
                print(error)
            } else {
                
                if let placemark:CLPlacemark = CLPlacemark(placemark: placemarks![0]),
                   let addressDictionary = placemark.addressDictionary,
                   let state = addressDictionary["State"],
                   let city = addressDictionary["City"],
                   let zip = addressDictionary["ZIP"],
                   let street = addressDictionary["Street"]
                {
                    print(placemark.addressDictionary)
                    
                    self.sendLocation(MemorablePlace(name: "Name", address: "\(street)\n\(city), \(state) \(zip)")!)
                }
            }
        }
        
    }
    
    func sendLocation(location: MemorablePlace) {
        
        // Create the alert controller.
        let alert = UIAlertController(title: nil, message: "What is the name of this place?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add the text field
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "Name"
        })
        
        // Grab the value from the text field when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            if let title = alert.textFields![0].text {
                location.title = title
                self.onLocationAvailable?(location: location)
            }
        }))
        
        // Show the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

