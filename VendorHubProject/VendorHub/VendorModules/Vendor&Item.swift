//
//  Item.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/24/22.
//

import Foundation
import Firebase
import FirebaseFirestore


struct Item {
    var id: String
    var itemDescription: String
    var price: String
    var itemID: String
    
    //var details: String
    
    init(_ dictionary: [String: Any],itemID:String) {
        self.itemDescription = dictionary["ItemDescription"] as! String? ?? ""
        self.price = dictionary["ItemPrice"] as? String ?? ""
        self.id = dictionary["Image"] as? String ?? ""
        self.itemID = itemID
        //add image here also the price as well
    }
}

class Vendor {
    
    var id: String = ""
    var storeName: String = ""
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var Items: [Item] = []
    
    var db: Firestore!
    var currentUser: Auth
    
    init() {
        db = Firestore.firestore()
        currentUser = Auth.auth()
    }
    //i know
    //dso idea is that when I get the data, I will make a new Item class, for

    //then store it in a class, that hold it, the vendor
   
    
    //function to load Itme 
    
    func loadItemsData(completed: @escaping (_ dataGet: Bool) -> Void) {
        
      
        db.collection("Vendor").document(currentUser.currentUser!.uid).collection("Items").addSnapshotListener {(QuerySnapshot, Error) in
            guard Error == nil else {
                print("Error getting data")
                return completed(false)
            }
            self.Items = []
            for document in QuerySnapshot!.documents {
                print(document.data())
                //put the item id for every item as well, then can check if its!!
                let item = Item.init(document.data(),itemID: document.documentID)
                self.Items.append(item)
            }
            print("Done Here")
            completed(true)
        }
        
    }
}
