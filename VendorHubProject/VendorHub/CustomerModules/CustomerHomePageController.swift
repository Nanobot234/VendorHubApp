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
    
    
    var vendorItems = [Model]()
    var testItems = [Model]() //will pass this as the a
    var vendorNames:[String] = []
    var vendorIDS:[String] = []
    let auth = Auth.auth()
    let db = Firestore.firestore()
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
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //signing out//need to USe Unwind .
    @IBAction func gotoHome(_ sender: Any) {
        do {
            try auth.signOut()
            
            let customerChoiceVC = homeStoryboard.instantiateViewController(withIdentifier: "customerOption")
            
            navigationController?.pushViewController(customerChoiceVC, animated: true)
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //save this to databse thenn
    }
    
    //gets all the vendor data fornow, should marcha certain description
    func getVendorData(completed: @escaping (_ data:[Model]) -> Void) {
        //grap the dataa, first grab all documents, then look in the documents for the items collection
        //then grab all the documents under items
        var itemsArray = [Model]()
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
            for document in QuerySnapshot!.documents {
                
                print("Second Here")
                print(document.documentID)
                self.vendorIDS.append(document.documentID) //get the ids of all the vendors
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
            print(querySnapsht!.documents.count)
            
            for document in querySnapsht!.documents {
                
                let model = Model(document.data())
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
        
        cell.tableCellIndexPath = indexPath.row
        //puts the test items in the
        cell.configure(with: testItems) //puts the items in the collectionView?
        //here is where it puhts items in collection viee
        
        cell.cellDelegate = self
        return cell
        
        
        //      return UITableViewCell()
    }
    
    //to set the title of each row of tableView
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //if statement maybe if its at the end
        
        if(vendorNames.isEmpty == true) {
            return nil
        }
        return vendorNames[section]
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
    
    var price: String = ""
    var itemDescription: String = ""
    let db = Firestore.firestore()
    
    
    
    init( _ dictionary: [String:Any]) {
        self.itemDescription = dictionary["ItemDescription"] as! String? ?? ""
        self.price = dictionary["ItemPrice"] as! String? ?? ""
        self.imageName = dictionary["Image"] as! String? ?? ""
        print(dictionary)
        
    }
    
    
    
}

extension CustomerHomePageController:CollectionViewCellDelegate  {
    
    func collectionView(collectionviewcell: CollectionViewCell?, index: Int, didTappedInTableViewCell: CollectionTableViewCell) {
        
        
        let itemVC = storyboard?.instantiateViewController(withIdentifier: "imageDetailsView") as! ItemPriceDescriptionController
        
        itemVC.image = (collectionviewcell?.myImage.image)!
        //also set the image url, that will be saved..
        
        
        itemVC.itemDescriptionText = collectionviewcell!.itemDescription
        
        itemVC.itemPriceText = "$" + collectionviewcell!.itemPrice
        
        //here is the image URL,
        itemVC.imageURL = collectionviewcell!.setImageURL
        //pass the image URL
        
        
        //here the row your on, pass the id. from the row that
        let selectedIndex =  didTappedInTableViewCell.tableCellIndexPath
        
        //sets the vendor id here
        itemVC.vendorID = vendorIDS[selectedIndex]
        
        //then get the current price
        navigationController?.pushViewController(itemVC, animated: true)
        //to pass the correct item description will take the
        
    }
    
    
}

