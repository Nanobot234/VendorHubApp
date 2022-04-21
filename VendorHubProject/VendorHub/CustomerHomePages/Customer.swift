//
//  Customer.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/13/22.
//

import Foundation
import FirebaseAuth

class Customer {

    var name:String
    var email:String
    var Location:String
    var ErrorWithLogin:Bool
    let auth = Auth.auth()
    
    init(newName:String,email:String){
        self.name = newName
        self.email = email
        self.Location = ""
        self.ErrorWithLogin = false
    }
    
    func setCusotomerName(newName:String){
        self.name = newName
    }
    
    func setCustomerEmail(newCustomerEmail:String){
        self.email = newCustomerEmail
    }





}
