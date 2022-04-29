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

//need to make a function that grabs those images, anfd then!!!

class CustomerHomePageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var vendorItems = [Model]()
    var testItems = [Model]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var imageData:Data!
    
    var imagetoSend:UIImage!
    var vendorPositon = ["Vendor 1","Vendor 2","Vendor 3","Vendor 4","Vendor5"]
    
    @IBOutlet var table: UITableView!
    // var itemController:CustomerHomePageController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
        //  self.table.snapshotView(afterScreenUpdates: true)
        
    }
    
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

                group.enter()
            for document in QuerySnapshot!.documents {
                print("Second Here")
                print(document.documentID)
                
                self.getVendorItems(document.documentID) { data in
                    print("Vendor Items Completion")
                    itemsArray.append(contentsOf: data)
                    
                    group.leave()
                }
                
                
            }
            
            print("Completed Here")
            group.notify(queue : DispatchQueue.global()) {
                    completed(itemsArray)
                }
        }
        
        //
        
    }
    
    func getVendorItems(_ docID: String, completed: @escaping (_ data:[Model]) -> Void) {
        
        var itemsArray = [Model]()
        
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
    
    
    //    func loadImagesfromFirebase(_ documentData:[String:Any]) -> Data? {
    //       //idea is to get the image name and label for the items, then populate them into the vendoritems, right!
    //        //hve to get image from specofied vendor
    //
    //        let imageURL = documentData["Image"]
    //        guard let urlImageString = imageURL as? String,
    //              let url = URL(string: urlImageString) else {
    //                  return nil
    //   }
    //        URLSession.shared.dataTask(with: url) { data, _, error in
    //            guard let data = data, error == nil else{
    //                return
    //            }
    //            //was trying to set the image for every cellm here, but I can call this indide the struct and then set it there
    //            self.imageData = data
    //            print(data.description)
    //            //also the image I will set is not the user defaults, but the one grabbed from firebase,  visualize
    //
    //
    //        }
    //
    //        return self.imageData
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //
        
    }
    //tableview sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vendorPositon.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell {
            
            cell.configure(with: testItems) //puts the items in the collectionView?
            //here is where it puhts items in collection viee
            
            cell.cellDelegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    //to set the title of each row of tableView
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vendorPositon[section]
    }
    
    //sets the row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    //Collection View inside a table view
    
    
    //But will need  page where to upload items, or can mually do i
    
    
    //this ia going to be the image that we are getting from firebase, for the ros
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemDetailsView" {
            let destination = segue.destination as! ItemPriceDescriptionController
            
            destination.selectedImage.image = self.imagetoSend
        }
        
    }
    
}


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
        
        
        
        //should make the image and work lol
        //   imageViewPage.selectedImage = UIImage(named: coll)
        self.imagetoSend = didTappedInTableViewCell.imageView
        
        
        self.performSegue(withIdentifier: "itemDetailsView", sender: self)
        
        
        
        
    }
    
    
}

