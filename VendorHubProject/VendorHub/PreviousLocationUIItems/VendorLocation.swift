//
//  VendorLocation.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/30/22.
//

import Foundation


struct VendorLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
