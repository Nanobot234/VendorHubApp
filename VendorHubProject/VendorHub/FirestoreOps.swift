//
//  FirestoreOps.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/6/22.
//

import Foundation
import Firebase


class FirestoreOps {
 
    
    
    static func getVendorName(vendorID:String) -> String {
        var vendorName = ""
        let db = Firestore.firestore()
        var vendors = db.collection("Vendor")
            
        vendors.document(vendorID).getDocument { document, error in
            if(error == nil){
                vendorName = document?.get("Store name") as! String
             
            }
            
        }
        
        
        
        return vendorName
    }
    
}
