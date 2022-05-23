//
//  CartItemCell.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/6/22.
//

import UIKit

class CartItemCell: UITableViewCell {

  
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var StoreName: UILabel!
    

    //itemDescription.layer.borderWidth = 2.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        itemDescription.layer.borderWidth = 0.25
        itemDescription.layer.cornerRadius = 5.0
        
        itemPrice.layer.borderWidth = 0.25
        itemPrice.layer.cornerRadius = 5.0
        
        StoreName.layer.borderWidth = 0.25
        StoreName.layer.cornerRadius = 5.0
        
        itemImage.layer.cornerRadius = 5.0
    }

    @IBOutlet weak var QuanityLabel: UILabel!
//Maye change due to conflict
    
    
}
