//
//  Customer.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/13/22.
//


//ignore this class for now, I have not used it as of now




import Foundation
import FirebaseAuth

struct cartItem: Codable {

    var vendorID:String
    var itemImage:Data
    var itemDescription:String
    var itemPrice:String
    var itemID:String?//this will the itemID in the vendor storage
    
}

struct cartArray: Codable {
    var cartItems: [cartItem] = Array()
    
}
