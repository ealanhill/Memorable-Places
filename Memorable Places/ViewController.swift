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

    @IBOutlet var map: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up our location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // long press
        let uilpgr = UILongPressGestureRecognizer(target: self, action:  "action:")
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latDelta:CLLocationDegrees = 0.1
        let longDelta:CLLocationDegrees = 0.1
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let center:CLLocationCoordinate2D = locations[0].coordinate
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        
        self.map.setRegion(region, animated: false)
    }*/
    
    func action(gestureRecognizer: UIGestureRecognizer) {
        print("Gesture Recognized")
        
        let touchPoint = gestureRecognizer.locationInView(self.map)
        
        let center: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        print(center)
        
        let latDelta:CLLocationDegrees = 0.1
        let longDelta:CLLocationDegrees = 0.1
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        
        self.map.setRegion(region, animated: true)
        
        /*CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if(error != nil) {
                print(error)
            } else {
                
                if let placemark:CLPlacemark = CLPlacemark(placemark: placemarks![0]) {
                    print(placemark.addressDictionary)
                    
                    if let locationName = placemark.addressDictionary!["Name"] as? NSString,
                       let city = placemark.addressDictionary!["City"] as? NSString,
                       let state = placemark.addressDictionary!["State"] as? NSString,
                       let zip = placemark.addressDictionary!["ZIP"] as? NSString
                    {
                        annotation.title = "\(locationName)\n\(city), \(state) \(zip)"
                        self.map.addAnnotation(annotation)
                    }
                }
            }
        }*/
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TableViewControllerSegue" {
            let tableViewController = segue.destinationViewController as! TableViewController
            
            let center = self.map.centerCoordinate
            
            let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
            tableViewController.addLocation(location)
        }
    }

}

