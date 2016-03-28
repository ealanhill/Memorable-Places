//
//  MemorablePlace.swift
//  Memorable Places
//
//  Created by E Alan Hill on 3/25/16.
//  Copyright © 2016 619 Fitness. All rights reserved.
//

import Foundation

@objc(MemorablePlace)
class MemorablePlace: NSObject {
    //MARK: Properties
    var title: String
    var address: String
    var latitude: Double
    var longitude: Double
    override var description: String {
        return "\(title), \(address), \(latitude) \(longitude)"
    }
    
    // MARK: Initialization
    init?(name: String, address: String, latitude: Double, longitude: Double) {
        // initialize our two properties
        self.title = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        
        // initialize our super class
        super.init()
        
        // initialization should fail if there is no title or address
        if(self.title.isEmpty || self.address.isEmpty) {
            return nil
        }
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObjectForKey("title") as! String
        self.address = decoder.decodeObjectForKey("address") as! String
        self.latitude = decoder.decodeDoubleForKey("latitude")
        self.longitude = decoder.decodeDoubleForKey("longitude")
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.address, forKey: "address")
        coder.encodeDouble(self.latitude, forKey: "latitude")
        coder.encodeDouble(self.longitude, forKey: "longitude")
    }
}

// globally scope the operator overload so we can determine if an array
// contains the MemorablePlace already
func ==(lhs: MemorablePlace, rhs: MemorablePlace) -> Bool {
    return (lhs.title == rhs.title) && (lhs.address == rhs.address)
}