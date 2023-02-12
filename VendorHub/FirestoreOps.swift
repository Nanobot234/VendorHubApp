//
//  FirestoreOps.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/6/22.
//

import Foundation
import Firebase
import CoreLocation




class FirestoreOps {
    static let shared = FirestoreOps() //use this as a singeton 
    
     var db = Firestore.firestore()
    var auth = Auth.auth()
   // static var customerCoordinates = [Double]()
     var vendorCoordinates = [Double]()
     var timeDistance = 0
    
    func getAccountType(userID:String,completed:@escaping (String) -> Void) {
        
        //actually can search if collection has that id!
        isVendor(userID: userID) { result in
            if(result == true) {
                completed("Vendor")
            } else {
                completed("Customer")
            }
        }
        
        //tgry both accountt ypes
    }
//
    
    //function to check whe
    func isVendor(userID:String,completed:@escaping (Bool) -> Void) {
    
            //following closure checks whether the ID is in the vendor part o databse. If so then thats good
        
        
        db.collection("Vendor").document(userID).getDocument { docSnapshot, err in
            
        
            if(err == nil) {
              completed(true)
            } else {
                completed(false)
            }
        }
        
    
//    db.collection("cities").whereField("capital", isEqualTo: true)
//        .getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//    }
}
     func getVendorName(vendorID:String,completed:@escaping (String) -> Void)  {
      
    
       
        let vendors = db.collection("Vendor")
            
        vendors.document(vendorID).getDocument { document, error in
            if(error == nil){
                 let vendorName = document?.get("StoreName") as! String
                //a sync call here
                completed(vendorName)
                
            }
            
        }
        
    
    }
    
     func savenewLocation(userID:String,longitude:Double,latitude:Double,userType:String) {
        
        if(userType == "customer") {
            db.collection("Customer").document(userID).setData(["longitude": longitude,"latitude":latitude], merge:true)
        } else {
            db.collection("Vendor").document(userID).setData(["longitude": longitude,"latitude":latitude], merge:true)
        }
    }
    
    //sets an order into the vendor firestore, based on the order number, will make an array for each item to hold the darta
     func setOrderItem(customerID:String,iteminfo:[cartItem],completed:@escaping (Bool) -> Void) {
        //idea is that for each cart item will store order  in the respecitve place giver the vendorID
  
         
         //[cartItem} this cart holds all items customer desires. Each item has a vendorID. Items with the same vendorIDS, need to be grouped toogether,
         
         //with each group item list having the same order num
         
         //first items with the vendor IDS need to be grouped together
         
         //this dicitionary maps each vendor to the items assocaited with them that the customer has chosen
         var vendorOrders = [String:[cartItem]]()
         
        
         for item in iteminfo {
             
             let vendorID = item.vendorID!
             
             if(vendorOrders[vendorID] == nil){
                 var vendorItems = cartArray()
                 vendorItems.cartItems.append(item)
                 //now you save the items belonging to that vendor to the dicitionary value
                 vendorOrders[vendorID] = vendorItems.cartItems
             } else {
                 var items = vendorOrders[vendorID] //array of VendorItems
                 items?.append(item)
                 vendorOrders[vendorID] = items!
             }
         //now for each item
         }
         
         //now vendorOrders will have correct mappi
         
         for (vendID,items) in vendorOrders {
             let orderNum = UUID().uuidString.prefix(4)
             
             var orderTotal = 0
             
             //all items here belong to one vendor, and the list represents the order for that vendor
             for item in items {
                 var itemArray = [String]()
                 let itemPlace = UUID().uuidString.prefix(3)
                 
                 itemArray.append(item.itemPrice)
                 itemArray.append(item.itemDescription)
                 itemArray.append(item.imageURL!)
                 itemArray.append(item.quantity!)
                 let itemPriceAmt = Int(item.itemPrice)!
                 
                 orderTotal += itemPriceAmt
                 
                 db.collection("Vendor").document(vendID).collection("Current Orders")
                     .document(String(orderNum)).setData([String(itemPlace):itemArray,"customerID":customerID,"orderTotal":0], merge: true)
                 
                 getVendorName(vendorID: vendID) { name in
                     self.db.collection("Customer").document(customerID).collection("Current Orders").document(String(orderNum)).setData([String(itemPlace):itemArray,"VendorName":name,"VendorID":vendID,"orderTotal":0], merge: true)
                 
             }
                 
                 
             }
             
             db.collection("Vendor").document(vendID).collection("Current Orders")
                 .document(String(orderNum)).updateData(["orderTotal":orderTotal])
             
             db.collection("Customer").document(customerID).collection("Current Orders")
                 .document(String(orderNum)).updateData(["orderTotal":orderTotal])
             
           orderTotal = 0
             
             
         }
     
         completed(true)
     
         
     }
          
        
        
        
        

  //  idea is on a completed order put it in the customer completed order, then also the vendor completed or
    
    func setCompletedOrder(vendorID:String,custID:String,orderNum:String,items:[cartItem]) {
        

        //include data as well!
        for item in items {
              //append each
            var itemArray = [String]()
            let itemPlace = UUID().uuidString.prefix(3)
            
            itemArray.append(item.itemPrice)
            itemArray.append(item.itemDescription)
            itemArray.append(item.imageURL!
            )
     
           
        db.collection("Vendor").document(vendorID).collection("Past Orders").document(orderNum).setData([String(itemPlace): itemArray], merge: true)
            
                db.collection("Customer").document(custID).collection("Past Orders").document(orderNum).setData([String(itemPlace): itemArray], merge: true)
            
    }
    
    }
    
    
    func getPastOrdersforUser(userID:String,accountType:String,completed:@escaping (_ pastdata:[Customer]) -> Void) {
        
        var pastordersArray = [Customer]()
        if(accountType == "customer") {
            db.collection("Customer").document(userID).collection("Past Orders").addSnapshotListener { snapshot, error in
                guard error == nil else{
                    print("Error with items")
                    return
                }
                snapshot?.documentChanges.forEach({ change in
                    if(change.type == .added) {
                        let newCustomer = Customer(input: change.document.data() , CustorderNum: change.document.documentID)
                        pastordersArray.append(newCustomer)
                        completed(pastordersArray)
                        
                    }
                })
                
            }
        } else {
            db.collection("Vendor").document(userID).collection("Past Orders").addSnapshotListener { snapshot, error in
                guard error == nil else{
                    print("Error with items")
                    return
                }
                snapshot?.documentChanges.forEach({ change in
                    if(change.type == .added) {
                        let newCustomer = Customer(input: change.document.data() , CustorderNum: change.document.documentID)
                        pastordersArray.append(newCustomer)
                        completed(pastordersArray)
                        
                    }
                })
                
            }
            
        }
    }
    //or make array of customers?
    
     func getOrderItemsforVendor(vendorID:String,completed:@escaping (_ ordersdata:[Customer]) -> Void) {
        
        //the items that will be returned
        //but since items are in ana array, will access each array elememen..
        //all the customers u will get based on order
        
        var customerArray = [Customer]()
        db.collection("Vendor").document(vendorID).collection("Current Orders").addSnapshotListener { snapshot, error in
            
            guard error == nil else{
                print("Error with items")
                return
            }
            
            //shows new things only
            snapshot?.documentChanges.forEach({ change in
                if(change.type == .added) {
                    let newCustomer = Customer(input: change.document.data() , CustorderNum: change.document.documentID)
                    customerArray.append(newCustomer)
                  
                    
                }
            })
            //now loop through the orders, and create the cusotmer objects
        
                //will get a dictonaryw with
            completed(customerArray)
        }
        
    }
    
    
    //need to get items for the customer,
    //since its saved, for each order will make a customer, and then will get
    
     func getOrderItemsforCustomer(customerID:String,completed:@escaping ( _ ordersdata:[Customer]) -> Void) {
        
        var customerArray = [Customer]()
        //once again, lol make a customer, for each different vendor, and the databse organizes it by vendor
        
         print("Retrieved order for",customerID)
        db.collection("Customer").document(customerID).collection("Current Orders").addSnapshotListener { snapshot, error in
            
            snapshot?.documentChanges.forEach({ change in
                if(change.type == .added) {
                  //  for document in snapshot!.documents {
                    //basically if you added a new docuemnt than you return it to this
                    let newCustomer = Customer(input: change.document.data() , CustorderNum: change.document.documentID)
                        customerArray.append(newCustomer)
                    
                    //}
                }
            })
            
            
            completed(customerArray)
        }
    }
    
     func getCustomerLocationCoordinates(customerID:String,completed:@escaping (_ custID:[Double]) -> Void) {
        
       
        db.collection("Customer").document(customerID).getDocument { document, error in
            if(error == nil){
                var coordinateArray = [Double]()
                 let longitude = document?.get("longitude") as! Double
                let latitude = document?.get("latitude") as! Double
                
                coordinateArray.append(longitude)
                coordinateArray.append(latitude)
                //a sync call here
                completed(coordinateArray)
                
            }
        }
        
        
        
    }
    
     func getVendorLocationCoordinates(vendorID:String,completed:@escaping (_ vendID:[Double]) -> Void) {
        
       
        db.collection("Vendor").document(vendorID).getDocument { document, error in
            if(error == nil){
                var coordinateArray = [Double]()
                 let longitude = document?.get("longitude") as! Double
                let latitude = document?.get("latitude") as! Double
                
                coordinateArray.append(longitude)
                coordinateArray.append(latitude)
                //a sync call here
                completed(coordinateArray)
                
            }
        }
        
    }
    
    
    //basically will look at changes to the customer location database,if so will get the coordinate values, the
    //with those values, you calculate the time distance, to th
    
    //maybe chnage to the coordinayes
    
    
    func checkCustomerDistance(vendLat:Double,vendLong:Double,customerID:String,completed:@escaping (_ timeDistance:Int) -> Void) {
        
        db.collection("Customer").document(customerID).getDocument { snapshot, error in
            
            let customerLatitude = snapshot?.get("latitude") as! Double
            let customerLongitude = snapshot?.get("longitude")  as! Double
            
            let customerLocation = CLLocation(latitude: customerLatitude, longitude: customerLongitude)
            
            let vendorLocation = CLLocation(latitude: vendLat, longitude: vendLong)
            
            let distance = vendorLocation.distance(from: customerLocation) / 1000
            
            let averageSpeed = 1.42
            let timetoCustomer = Int(distance/averageSpeed)
            
            completed(timetoCustomer)
        }
            
         
        }
        
    
    

    
    //given coordinate calculate the distance, then estimate it in time,
    func calculateLocationTimeDistance(vendorID:String,custLongitude:Double,custLatitude:Double,completed:@escaping (_ timeDistance:Int) -> Void){
        
            getVendorLocationCoordinates(vendorID: vendorID) { vendID in
                
                
                let customerLocation = CLLocation(latitude: custLatitude, longitude: custLongitude)
                
                let vendorLocation = CLLocation(latitude: vendID[1], longitude: vendID[0])
                
                let distance = customerLocation.distance(from: vendorLocation) / 1000
                
                let averageSpeed = 1.42
                let timetoVendor = Int(distance/averageSpeed)
                
                
                print(timetoVendor)
                
               completed(timetoVendor)
               
            }
    
    }
    
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
     func convertBase64StringToImage(imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    /*
    deletion methods
     */
     func deleteVendorItem(vendorID:String, itemID:String) {
        
        db.collection("Vendor").document(vendorID).collection("Items").document(itemID).delete()
    }
    
    func deleteOrderforUser(userID:String,orderNum:String,accountType:String) {
            
        if(accountType == "vendor") {
        db.collection("Vendor").document(userID).collection("Current Orders").document(orderNum).delete()
        } else if(accountType == "customer") {
            db.collection("Customer").document(userID).collection("Current Orders").document(orderNum).delete()
        }
    

    }
    
}
