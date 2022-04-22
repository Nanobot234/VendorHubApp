//
//  CustomerHomePageController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/21/22.
//

import Foundation
import UIKit



class CustomerHomePageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var vendorItems = [Model]()
    
    
    var vendorPositon = ["Vendor 1","Vendor 2","Vendor 3","Vendor 4","Vendor5"]
    
   @IBOutlet var table: UITableView!
        // var itemController:CustomerHomePageController
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding model objects with images to the Items
        vendorItems.append(Model("Image1"))
        
        vendorItems.append(Model("Image2"))
        
        vendorItems.append(Model("Image3"))
        
        vendorItems.append(Model("Image4"))
        
        vendorItems.append(Model("Image5"))
        
       //make a new view controller
        
        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //
        
    }
    //tableview sections

    func numberOfSections(in tableView: UITableView) -> Int {
        return vendorPositon.count
    }
    
  

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell {
        
            cell.configure(with: vendorItems) //puts the items in the collectionView?
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
   
    public func loadImagesfromFirebase() {
        //idea is to get the image name and label for the items, then populate them into the vendoritems, right!
    }

//this ia going to be the image that we are getting from firebase, for the ros

}


struct Model {
    let imageName: String
    
    init(_ imageName: String) {
        self.imageName = imageName
    }
    
    
}

extension CustomerHomePageController:CollectionViewCellDelegate {
    func collectionView(collectionviewcell: CollectionViewCell?, index: Int, didTappedInTableViewCell: CollectionTableViewCell) {
        
        let imageViewPage:ItemPriceDescriptionController = self.storyboard?.instantiateViewController(withIdentifier: "imageDetailsView") as! ItemPriceDescriptionController
        
        //should make the image and work lol
     //   imageViewPage.selectedImage = UIImage(named: coll)
            self.performSegue(withIdentifier: "itemDetailsView", sender: self)
       
      
        
        
    }
    
    
}

