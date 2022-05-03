//
//  ItemPriceDescriptionController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/2/22.
//

import UIKit

//cklass to show to show the item selected by Customer
class ItemPriceDescriptionController: UIViewController {

    @IBOutlet weak var selectedImage:UIImageView!
    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    var itemDescriptionText = ""
    var itemPriceText = ""
    
    var vendorID = ""
    var image = UIImage()
    
    //in here, will hold the item price, description, and the vendorID as well
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemDescriptionLabel.text = itemDescriptionText
        itemPriceLabel.text = itemPriceText
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedImage.image = image
        
        print(vendorID)
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
