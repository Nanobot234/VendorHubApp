//
//  VendorLocation.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/21/22.
//

import Foundation

import CoreLocation
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth
import MapKit


//removed Codable after after added MKAnotation
class VendorLocation: NSObject, Codable {
    var address: String
    var latitude: Double
    var longitude: Double
    
//    var dictionary: [String: Any?] {
//        return ["address": address, "latitude": latitude, "logitude": longitude]
//    }
//
    
    init(address: String, latitude: Double, longitude: Double){
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    convenience override init() {
        self.init(address: "", latitude: 0.0, longitude: 0.0)
    }
    
}

