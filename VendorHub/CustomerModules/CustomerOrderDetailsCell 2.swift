//
//  CustomerOrderDetailsCell.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/18/22.
//

import UIKit

//defines the UI items that show the order that the customer has made
class CustomerOrderDetailsCell: UITableViewCell {


    @IBOutlet weak var itemImage: UIImageView!
    
    
    @IBOutlet weak var itemPrice: UILabel!
    
    
    @IBOutlet weak var itemQuantity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        itemPrice.layer.borderWidth = 0.25
        itemPrice.layer.cornerRadius = 5.0
        
        itemQuantity.layer.borderWidth = 0.25
        itemQuantity.layer.cornerRadius = 5.0
        
        
        
        itemImage.layer.cornerRadius = 5.0
    }
    
    
}
