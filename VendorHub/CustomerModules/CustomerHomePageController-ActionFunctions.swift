//
//  CustomerHomePageController-ActionFunctions.swift
//  VendorHub
//
//  Created by Nana Bonsu on 12/27/22.
//

import Foundation
import CoreLocation


extension CustomerHomePageController {
    
    //signing out//need to USe Unwind .
    @IBAction func gotoHome(_ sender: Any) {
        do {
            try auth.signOut()
            
         
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    @IBAction func refreshVendors(_ sender: Any) {
        self.table.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        FirestoreOps.shared.savenewLocation(userID: (auth.currentUser?.uid)!, longitude: locValue.longitude, latitude: locValue.latitude, userType: "customer")
        
        self.userLatitude = locValue.latitude
        self.userLongitude = locValue.longitude
        
        
        //save this to databse then
        
        //TODO: have to check if distance changes actually reloads the table view,
    }
    
    
    
    //gets all the vendor data fornow, should marcha certain description
    func getVendorData(completed: @escaping (_ data:[Model]) -> Void) {
        //grap the dataa, first grab all documents, then look in the documents for the items collection
        //then grab all the documents under items
        var itemsArray = [Model]() //i
        db.collection("Vendor").getDocuments() { (QuerySnapshot,Error) in
            guard Error == nil else {
                print("Error")
                return
            }
            
            let group = DispatchGroup()
            
            //   group.enter()
            //looping through all the vendors that youve gotten
            group.enter()
            var documentCount = QuerySnapshot?.documents.count
            var i = 0
            
            //looping all the vendors
            for document in QuerySnapshot!.documents {
                
                print("Second Here")
                print(document.documentID)
                self.vendorIDS.append(document.documentID) //get the ids of all the vendors, will be used to get the location
                //get the name
                let vendorName = document.get("StoreName")
                self.vendorNames.append(vendorName as! String)
                
                self.getVendorItems(document.documentID) { data in
                    i += 1
                    print("Vendor Items Completion")
                    itemsArray.append(contentsOf: data)
                    
                    
                    print("i \(i)")
                    print("Document Count: \(documentCount!)")
                    
                    //make sure i and doccount are the same
                    if(i == documentCount!) {
                        group.leave()
                    }
                    
                }
                
            }
            
            print("Completed Here")
            group.notify(queue : DispatchQueue.global()) {
                print("Items grabbed")
                completed(itemsArray)
            }
        }
    }
    
    //get the vendor items for the specified vendor
    func getVendorItems(_ docID: String, completed: @escaping (_ data:[Model]) -> Void) {
        
        var itemsArray = [Model]()
        
        //check whether the path exists
        self.db.collection("Vendor").document(docID).collection("Items").getDocuments { querySnapsht, Error in
            guard Error == nil else {
                print("Error with Items")
                return
            }
            print("Hello World")
            print("Document Amount",querySnapsht!.documents.count)
            
            for document in querySnapsht!.documents {
                
                //here for each item grab the id
                let model = Model(document.data(),ItemID: document.documentID,vendorID: docID)
                itemsArray.append(model)
            }
            completed(itemsArray)
        }
        
        
    }
    
    
//function that recieves a UIButton as a parameter.
    //is used to show all the Vendor Items when pressing seeAll button
    @objc func TableRowButton(sender: allItemsButton) {
     
     //instanite view controller then set the items array as the one that is passed in.
     
     let allVendorItems = storyboard?.instantiateViewController(withIdentifier: "allVendorItems") as! AllVendorItemsViewController
     
     allVendorItems.vendorItems = sender.Items

     navigationController?.pushViewController(allVendorItems, animated: true)
 }
    
    
}
