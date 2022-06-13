//
//  CustomerOrderStoreCell.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/18/22.
//

import UIKit

class CustomerOrderStoreCell: UITableViewCell {


    @IBOutlet weak var customerorderNum: UILabel!
    
    @IBOutlet weak var vendorStore: UILabel!
    
    @IBOutlet weak var getVendorDirections: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        customerorderNum.layer.borderWidth = 0.25
        customerorderNum.layer.cornerRadius = 5.0
        
        vendorStore.layer.borderWidth = 0.25
        vendorStore.layer.cornerRadius = 5.0
        
        
        
        getVendorDirections.layer.cornerRadius = 5.0
    }
    
}
