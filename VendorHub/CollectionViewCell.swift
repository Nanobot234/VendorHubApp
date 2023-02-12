//
//  VendorHeaderRow.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/25/22.
//

import Foundation
import UIKit

// NOTE::::  this class just defines the cellm, not the whole view controller


class CollectionViewCell: UICollectionViewCell{
    
   
    @IBOutlet var myImage:UIImageView!
   // let storyboard = UIStoryboard(name:"CustomerUserFlow", bundle: nil)
    
    var itemPrice = ""
    var itemDescription = ""
    var tablecellindex = 0;
    //the URL of the image to pass on
    var setImageURL = ""
    var itemID = ""
  var vendorID = ""
   
    static let indentifier = "CollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "CollectionView", bundle:nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib() //get an excplkanation for thi
        
       myImage.isUserInteractionEnabled = true
        
      
        
    }
    
    
    public func configure(with model:Model) {
        //change this to to configureing 
        self.myImage.setImage(model.imageName)
        self.itemPrice = model.price
        self.setImageURL = model.imageName
        self.itemDescription = model.itemDescription
        self.myImage.contentMode =  .scaleAspectFill
        self.itemID = model.itemID
        self.vendorID = model.vendorID
        
    }
   
    
    
    //maybe load from firebase there
    
    
    
    //create  table vieww cell
}
