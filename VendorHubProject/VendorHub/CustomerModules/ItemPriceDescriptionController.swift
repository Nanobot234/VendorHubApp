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
    
    @IBOutlet weak var AddtoCartButton: UIButton!
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
    
    // In this function the current item is added to the cart
    @IBAction func addItemToCart(_ sender: UIButton) {
        //First save the item as a cartItem , then pass it to user defaults?
        
        //idea is to check if user defaults has an array,
        
        //then if it does , you want to add the cart item to the array of cart items
        
        let userDefaults = UserDefaults.standard
       
        var currentItem = cartItem(vendorID: self.vendorID, itemImage: self.selectedImage.image!.pngData()!, itemDescription: self.itemDescriptionLabel.text!, itemPrice: self.itemPriceLabel.text!)
        var cartArray:cartArray = cartArray()
        if(userDefaults.valueExists(forKey: "cartArray") == false) {
            //create an new array of type cart item, then add it
            cartArray.cartItems.append(currentItem)
            userDefaults.encodeCartData(data: cartArray.cartItems)
        }  else {
            cartArray.cartItems = userDefaults.decodeCartData()!
            cartArray.cartItems.append(currentItem)
            userDefaults.encodeCartData(data: cartArray.cartItems)
        }
        
        print(cartArray)
        
        
       
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
