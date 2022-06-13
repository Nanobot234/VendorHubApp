//
//  CustomerHomePageController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/21/22.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase
import simd
import MapKit
import CoreLocation

//need to make a function that grabs those images, anfd then!!!

class CustomerHomePageController: UIViewController, UITableViewDataSource, UITableViewDelegate ,CLLocationManagerDelegate {
    
    var distances:[String:Int] = [:]
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    var userLatitude:Double = 0.0
    var userLongitude:Double = 0.0
    var vendorItems = [Model]()
    var testItems = [Model]() //will pass this as the a
    var vendorNames:[String] = []
    var vendorIDS:[String] = []
    var pathArray:[IndexPath] = []
    var imageData:Data!
    
    let mystoryboard = UIStoryboard(name:"CustomerUserFlow" , bundle: nil)
    let homeStoryboard = UIStoryboard(name:"Main" , bundle: nil)
    let locationManager = CLLocationManager()
    var imagetoSend:UIImage!
    
    
    @IBOutlet var table: UITableView!
    // var itemController:CustomerHomePageController
    @IBOutlet weak var SignOutButton: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // self.vendorNames = []
        self.testItems = []
        self.vendorNames = []
        
        //gets the vendor Items
        self.getVendorData {data in
            print(data)
            self.testItems = data
            print("Test Items",self.testItems.count)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //only
            table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
            table.delegate = self
            table.dataSource = self
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.table.reloadData()
    }
    //signing out//need to USe Unwind .
    @IBAction func gotoHome(_ sender: Any) {
        do {
            try auth.signOut()
            
         performSegue(withIdentifier: "CustomertoHome", sender: self)
        } catch {
            print(error.localizedDescription)
        }
        
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
    
    
   
    
    ///Table View Metho
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //
        
    }
    //tableview sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vendorNames.count
        
   
        
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
        
        //here yu make the index Path
    
        
      //  cell.tableCellIndexPath =
        //puts the test items in the
        
        print("Test Items",self.testItems)
        cell.configure(with: testItems.filter({$0.vendorID == self.vendorIDS[indexPath.section]}))
        
        
        //puts the items in the collectionView?
        //here is where it puhts items in collection viee
        
                cell.cellDelegate = self
        
        
        print("Section Number",indexPath.section)
        
        let indexPath = IndexPath(row: indexPath.section, section: cell.tableCellIndexPath)
        //so at each row, you know that you hava an inde
        
        if(pathArray.contains(indexPath) == false) {
            pathArray.append(indexPath)
        }
        
        print(pathArray)
        FirestoreOps.shared.calculateLocationTimeDistance(vendorID: vendorIDS[indexPath.section], custLongitude: self.userLongitude, custLatitude: self.userLatitude) { timeDistance in
            
            self.distances[self.vendorIDS[indexPath.section]] = timeDistance
          
        
        }
      
        return cell
    }

    //to set the title of each row of tableView
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //if statement maybe if its at the end

    if(vendorNames.isEmpty == true) {
        return nil
       }

      
        print("Distances",distances)
        
       
       return self.vendorNames[section] + " - " + String(self.distances[self.vendorIDS[section]] ?? 0) + " min away"

    }
    
    //sets the row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    

    //Collection View inside a table view
    
    
    //But will need  page where to upload items, or can mually do i
    
    
    //this ia going to be the image that we are getting from firebase, for the ros
    
    
    
}


//a structure used to display the images that are held.
struct Model {
    var imageName: String //the url grabbed from firebse
    var vendorID: String
    var price: String = ""
    var itemDescription: String = ""
    let db = Firestore.firestore()
    var itemID = ""
    
    
    init( _ dictionary: [String:Any],ItemID:String,vendorID:String) {
        self.vendorID = vendorID
        self.itemID = ItemID
        self.itemDescription = dictionary["ItemDescription"] as! String? ?? ""
        self.price = dictionary["ItemPrice"] as! String? ?? ""
        self.imageName = dictionary["Image"] as! String? ?? ""
        
      //  print(dictionary)
        
    }
    
}

extension CustomerHomePageController:CollectionViewCellDelegate  {
    
    func collectionView(collectionviewcell: CollectionViewCell?, index: Int, didTappedInTableViewCell: CollectionTableViewCell,sectionNum:Int) {
        
        
        let itemVC = storyboard?.instantiateViewController(withIdentifier: "imageDetailsView") as! ItemPriceDescriptionController
        
        itemVC.image = (collectionviewcell?.myImage.image)!
        //also set the image url, that will be saved..
        
        
        itemVC.itemDescriptionText = collectionviewcell!.itemDescription
        
        itemVC.itemPriceText =  collectionviewcell!.itemPrice
        
       
        //here is the image URL,
        itemVC.imageURL = collectionviewcell!.setImageURL
        //pass the image URL
        
        itemVC.itemID = collectionviewcell!.itemID
    
        
        var tableRowIndex = 0
        
        for path in pathArray {
            //if you are
            if(path.section == didTappedInTableViewCell.tableCellIndexPath) {
                tableRowIndex = path.row
            }
        }
       // print("CurrIndex",selectedIndex!)
        //sets the vendor id here
        
        print("ItemIndex",collectionviewcell!.tablecellindex)
        
        print("CollectionItemIndex",didTappedInTableViewCell.tableCellIndexPath)
        
      //  print("SectionNum",sectionNum)
        itemVC.vendorID = collectionviewcell!.vendorID
        
        //then get the current price
        navigationController?.pushViewController(itemVC, animated: true)
        //to pass the correct item description will take the
        
    }
    
    
}

