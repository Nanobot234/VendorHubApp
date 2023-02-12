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

/// Controller  that manages the contents of the inital view that the customner sees, displaying the nearby vendors!!

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
        
        auth.addStateDidChangeListener { authentic, user in
            if user != nil {
                print("User is logged in")
            } else {
                self.performSegue(withIdentifier: "CustomertoHome", sender: self)
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.table.reloadData()
    }

    
    

    
    
    ///Table View Metho
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //
        
    }
    //tableview sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vendorNames.count
        
        
        
        
    }
    
    //this method makes each cell, be a collectionView Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell //now each cell inside is a collectionTableView Cell
        
        
        //TODO: Need to check if I can a aparamter to the selector function. Reason for this is to pass the info from the selected row to the next new controller https://stackoverflow.com/questions/24814646/attach-parameter-to-button-addtarget-action-in-swift
        
        
        
        
        //Debuging print line here
        print("Test Items",self.testItems)
        
        
        //configure the cell that  has collectionView with the desired items
        cell.configure(with: testItems.filter({$0.vendorID == self.vendorIDS[indexPath.section]})) //this filter statement configures the cell with the correct vendorID, by doing so loads the correct items as well, items being an array
        
        
        //puts the items in the collectionView?
        //here is where it puhts items in collection viee
        
        cell.cellDelegate = self
        
        
        print("Section Number",indexPath.section)
        
        let indexPath = IndexPath(row: indexPath.section, section: cell.tableCellIndexPath)
        //so at each row, you know that you hava an inde
        
        
        
        
        //calculting the distance for each cell
        
        // closure... calculates the time in minutes that the vendcor is away for the customer. then saves it
        FirestoreOps.shared.calculateLocationTimeDistance(vendorID: vendorIDS[indexPath.section], custLongitude: self.userLongitude, custLatitude: self.userLatitude) { timeDistance in
            
            self.distances[self.vendorIDS[indexPath.section]] = timeDistance
            
            
        }
        
            cell.AllItemsButton.Items = testItems.filter({$0.vendorID == self.vendorIDS[indexPath.section]}) //gives the button in each cell this items array, corrsponding to the vendot that its on
            
        cell.AllItemsButton.addTarget(self, action: #selector(self.TableRowButton), for: .touchUpInside)
            
    
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
   
    
    
    
        

    

 
    
    
   

}

////Outside of the ViewController class

/*
 A struct object that holds the data for each item of the vendor
 */



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
        
        ///
        ///Following fucntioj deals with tapping on the cell
        ///
        //collection View cell is the cell that is tapped on.
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
    
  
    

