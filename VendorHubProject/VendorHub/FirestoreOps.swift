//
//  FirestoreOps.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/6/22.
//

import Foundation
import Firebase


class FirestoreOps {
 
    static var db = Firestore.firestore()
    static var auth = Auth.auth()
    
    static func getVendorName(vendorID:String,completed:@escaping (String) -> Void)  {
      
    
       
        let vendors = db.collection("Vendor")
            
        vendors.document(vendorID).getDocument { document, error in
            if(error == nil){
                 let vendorName = document?.get("Store name") as! String
                //a sync call here
                completed(vendorName)
                
            }
            
        }
        
        
        
       
    }
    
    //sets an order into the vendor firestore, based on the order number, will make an array for each item to hold the darta
    static func setOrderItem(customerID:String,iteminfo:[cartItem],completed:@escaping (Bool) -> Void) {
        //idea is that for each cart item will store order  in the respecitve place giver the vendorID
        
        //so if have 1,2,3 from vendor1 andf 4 5 from
        
        //store as an array then add the data
        let orderNum = UUID().uuidString.prefix(4)
        //unique so array isnt overwritten
        //save the vendor
        for item in iteminfo{
            var vendorID = item.vendorID!
            //now make an array
            //make a ranodm code, just to store the different array and have their feidls
            
    
            let itemPlace = UUID().uuidString.prefix(3)
            var itemArray = [String]()
            itemArray.append(item.itemPrice)
            itemArray.append(item.itemDescription)
            itemArray.append(item.imageURL!)
            
            //TODO: Set the Order Total, here by getting setting the feild previously, then adding to it for each order item??
            
            
            db.collection("Vendor").document(vendorID).collection("Current Orders")
                .document(String(orderNum)).setData([String(itemPlace):itemArray], merge: true)
            
            //for customer also save the location coordinates, of that particular vendor??
            
            //will need to grab the customer ID as well, to place it in the correct place
            
//Saving the order for cutomer is different
            
            getVendorName(vendorID: vendorID) { name in
                
                db.collection("Customer").document(customerID).collection("Current Orders").document(String(orderNum)).setData([String(itemPlace):itemArray,"VendorName":name], merge: true)
            }
          
            
        }
        
        
        completed(true)
    }
    
    
    //have list of cart items, loop through make a document with vendor id, then put the items inside!!,

    //function to listen for changes and pull them from firebase
    //when you pull the orders should return a list  have a list of orders
    //put need to return a cart of
    
    //or make array of customers?
    
    static func getOrderItemsforVendor(vendorID:String,completed:@escaping (_ ordersdata:[Customer]) -> Void) {
        
        //the items that will be returned
        //but since items are in ana array, will access each array elememen..
        //all the customers u will get based on order
        
        var customerArray = [Customer]()
        db.collection("Vendor").document(vendorID).collection("Current Orders").addSnapshotListener { snapshot, error in
            
            guard error == nil else{
                print("Error with items")
                return
            }
            //now loop through the orders, and create the cusotmer objects
            for document in snapshot!.documents {
                let newCustomer = Customer(input: document.data() , CustorderNum: document.documentID)
                customerArray.append(newCustomer)
            }
                //will get a dictonaryw with
            completed(customerArray)
        }
        
    }
    
    
    //need to get items for the customer,
    //since its saved, for each order will make a customer, and then will get
    
    static func getOrderItemsforCustomer(customerID:String,completed:@escaping ( _ ordersdata:[Customer]) -> Void) {
        
        var customerArray = [Customer]()
        //once again, lol make a customer, for each different vendor, and the databse organizes it by vendor
        
        db.collection("Customers").document(customerID).collection("Current Orders").addSnapshotListener { snapshot, error in
            
            for document in snapshot!.documents {
                let newCustomer = Customer(input: document.data() , CustorderNum: document.documentID)
                customerArray.append(newCustomer)
            }
            
            completed(customerArray)
        }
    }
    
    
   static func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
   static  func convertBase64StringToImage(imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    
    
}
