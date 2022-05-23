//
//  TableViewCell.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/25/22.
//

import UIKit



class ItemDisplayCell: UITableViewCell {

    @IBOutlet weak var DescriptionLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        DescriptionLabel.layer.borderWidth = 0.25
        DescriptionLabel.layer.cornerRadius = 5.0
        
        PriceLabel.layer.borderWidth = 0.25
        PriceLabel.layer.cornerRadius = 5.0
        
        
        
        itemImage.layer.cornerRadius = 5.0
    }
    

    
}
