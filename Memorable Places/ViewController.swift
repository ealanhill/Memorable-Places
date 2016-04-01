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

/**
    ViewController to display the map to users, so they can select a Memorable Place.
 */
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // our location manager to get the users location
    var locationManager = CLLocationManager()
    // function to be called when we have a location to save as a memorable place,
    // i.e. aftera long press
    var onLocationAvailable : ((location: MemorablePlace) -> ())?
    // the annotation to be used when the user has selected a memorable place from their list
    var annotation:MemorablePlace?
    // the map that is displayed to the user
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        // call our super class function
        super.viewDidLoad()
        
        // set up our location manager, telling it this is the delegate
        locationManager.delegate = self
        // user the best accuracy possible
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // request access to the users location
        locationManager.requestWhenInUseAuthorization()
        
        // check to see if the location services is enabled for this device,
        // if it is, then start updating the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            
            // TODO: need to implement the update location function
            if let center = locationManager.location?.coordinate {
                let region:MKCoordinateRegion = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.1, 0.1))
                self.map.setRegion(region, animated: false)
            }
        }
        
        // set up the long press for the user to add a memorable location
        let uilpgr = UILongPressGestureRecognizer(target: self, action:  #selector(ViewController.longPress(_:)))
        uilpgr.minimumPressDuration = 2 // use 2 seconds
        map.addGestureRecognizer(uilpgr) // add the long press to the map
        
        // if the annotation is not null, then we need to add the annotation to the map
        if self.annotation != nil {
            addAnnotation(self.annotation!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        The action to be taken when the user presses on the screen for 2 seconds.
     
        - Parameter gestureRecognizer: used to determine what gesture the user is performing
     */
    func longPress(gestureRecognizer: UIGestureRecognizer) {
        // check to see if we have begun our long press, ensures that we don't receive multiple
        // long presses from a single press
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            // get the point on the map the user is touching
            let touchPoint = gestureRecognizer.locationInView(self.map)
            
            // convert the touch point to a coordinate on the map
            let center: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            // get the locations information from the map
            self.getSelectedLocation(CLLocation(latitude: center.latitude, longitude: center.longitude))
        }
    }
    
    /**
        Retrieves the selected locations information for display in the Memorable Places list.
     
        - Parameter location: the `CLLocation` selected on the map
     */
    private func getSelectedLocation(location: CLLocation) {
        // reverse geocode the location to retrieve the locations information
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            // if there was an error, print it
            if(error != nil) {
                print(error)
            // otherwise, grab all of the information we desire from the location
            } else if let placemark:CLPlacemark = CLPlacemark(placemark: placemarks![0]),
                   let addressDictionary = placemark.addressDictionary,
                   let state = addressDictionary["State"],
                   let city = addressDictionary["City"],
                   let zip = addressDictionary["ZIP"],
                   let street = addressDictionary["Street"]
            {
                //print(placemark.addressDictionary)
                
                // send the location as a MemorablePlace to the TableViewController
                self.sendLocation(MemorablePlace(name: "Name", address: "\(street)\n\(city), \(state) \(zip)", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)!)
            }
        }
        
    }
    
    /**
        Sends a `MemorablePlace` to the TableViewController so it can be saved and displayed to the user
     
        - Parameter memorablePlace: the `MemorablePlace` the user selected with a long press to be sent
                        to the TableViewController
     */
    private func sendLocation(memorablePlace: MemorablePlace) {
        
        // create the alert controller, asking the user for the name of the selected place
        let alert = UIAlertController(title: nil, message: "What is the name of this place?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the text field so the user can enter the name to the alert
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Name"
        })
        
        // grab the value from the text field when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // ensure they did not enter a blank
            if let title = alert.textFields![0].text {
                memorablePlace.title = title
                
                // add an annotation to the map so the user can see the location they selected
                self.addAnnotation(memorablePlace)
                // send the location to the TableViewController
                self.onLocationAvailable?(location: memorablePlace)
            }
        }))
        
        // show the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
        Adds an annotation to the map using the information contained in the memorable place.
    
        - Parameter memorablePlace the `MemorablePlace` an annotation is to be added to the map for
     */
    private func addAnnotation(memorablePlace: MemorablePlace) {
        //print("Adding annotation for \(memorablePlace)")
        //print("Map: \(map)")
        
        // create the annotation
        let annotation: MKPointAnnotation = MKPointAnnotation()
        // set the annotations location to the MemorablePlace's location
        annotation.coordinate = CLLocationCoordinate2D(latitude: memorablePlace.latitude, longitude: memorablePlace.longitude)
        // set the annotations title to the MemorablePlace's title
        annotation.title = title
        
        // create the region the map is to be centered on, i.e. where the MemorablePlace is located
        let region:MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.1, 0.1))
        // center the map on the desired region
        self.map.setRegion(region, animated: true)
        
        // finally, add the annotation to the map
        self.map.addAnnotation(annotation)
    }
    
    /**
        To be called to set the MemorablePlace the map is to be centered on when a user has selected it from
        the TableViewController.
     
        - Parameter memorablePlace: the `MemorablePlace` the user has selected
     */
    func setMemorablePlace(memorablePlace: MemorablePlace) {
        self.annotation = memorablePlace
    }

}

