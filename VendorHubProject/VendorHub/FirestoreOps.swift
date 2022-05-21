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
    static let shared = FirestoreOps()
    
     var db = Firestore.firestore()
    var auth = Auth.auth()
   // static var customerCoordinates = [Double]()
     var vendorCoordinates = [Double]()
     var timeDistance = 0
    
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
        
        let orderNum = UUID().uuidString.prefix(4)
        //unique so array isnt overwritten
        //save the vendor
        for item in iteminfo{
            let vendorID = item.vendorID!
            
            let itemPlace = UUID().uuidString.prefix(3)
            var itemArray = [String]()
            itemArray.append(item.itemPrice)
            itemArray.append(item.itemDescription)
            itemArray.append(item.imageURL!)
            
            
            //TODO: Set the Order Total, here by getting setting the feild previously, then adding to it for each order item??
            
            //include customer id
            db.collection("Vendor").document(vendorID).collection("Current Orders")
                .document(String(orderNum)).setData([String(itemPlace):itemArray,"customerID":customerID], merge: true)
            
          
            getVendorName(vendorID: vendorID) { name in
                
                self.db.collection("Customer").document(customerID).collection("Current Orders").document(String(orderNum)).setData([String(itemPlace):itemArray,"VendorName":name,"VendorID":vendorID], merge: true)
            }
          
            
        }
        
        
        completed(true)
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
    
     func getOrderItemsforCustomer(customerID:String,completed:@escaping ( _ ordersdata:[Customer]) -> Void) {
        
        var customerArray = [Customer]()
        //once again, lol make a customer, for each different vendor, and the databse organizes it by vendor
        
        db.collection("Customer").document(customerID).collection("Current Orders").addSnapshotListener { snapshot, error in
            
            snapshot?.documentChanges.forEach({ change in
                if(change.type == .added) {
                  //  for document in snapshot!.documents {
                    //basically if you added a new docuemnt than you return it to this
                    let newCustomer = Customer(input: change.document.data() , CustorderNum: change.document.documentID)
                        customerArray.append(newCustomer)
                    completed(customerArray)
                    //}
                }
            })
            
            
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
    
    
    //func checkCusttomerDistance(vend)
    

    
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
