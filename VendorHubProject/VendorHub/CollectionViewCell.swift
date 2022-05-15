//
//  VendorHeaderRow.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/25/22.
//

import Foundation
import UIKit


class CollectionViewCell: UICollectionViewCell{
    
   
    @IBOutlet var myImage:UIImageView!
   // let storyboard = UIStoryboard(name:"CustomerUserFlow", bundle: nil)
    
    var itemPrice = ""
    var itemDescription = ""
    var tablecellindex = 0;
    //the URL of the image to pass on
    var setImageURL = ""
   //  var viewController:CustomerHomePageController = CustomerHomePageController(nibName: nil, bundle: nil)
   
    static let indentifier = "CollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "CollectionView", bundle:nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib() //get an excplkanation for thi
        
       myImage.isUserInteractionEnabled = true
        
      //  myImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap)))
        
    }
    
    
    public func configure(with model:Model) {
        //change this to to configureing 
        self.myImage.setImage(model.imageName)
        self.itemPrice = model.price
        self.setImageURL = model.imageName
        self.itemDescription = model.itemDescription
        self.myImage.contentMode =  .scaleAspectFill
        
        
    }
   
    
    
    //maybe load from firebase there
    
    
    
    //create  table vieww cell
}
