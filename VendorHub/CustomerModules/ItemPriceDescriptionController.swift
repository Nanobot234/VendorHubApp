//
//  ItemPriceDescriptionController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/2/22.
//

import UIKit

import Firebase
//cklass to show to show the item selected by Customer, when the user taps on a collectioNVie
class ItemPriceDescriptionController: UIViewController {

    @IBOutlet weak var selectedImage:UIImageView!
    
    @IBOutlet weak var quantityPicker: UIPickerView!
    
    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    var itemDescriptionText = ""
    var itemPriceText = ""  //string value of text
    var auth = Auth.auth()
    
    @IBOutlet weak var AddtoCartButton: UIButton!
    var vendorID = ""
    var imageURL = ""
    var itemID = ""
    var image = UIImage()
    var quanityItems = ["1","2","3","4","5"]
    var selectedQuantity = ""
    //in here, will hold the item price, description, and the vendorID as well
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemDescriptionLabel.text = itemDescriptionText
        itemPriceLabel.text = "$" + itemPriceText
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedImage.image = image
        
        print(vendorID)
        //shouldnt be eimp
        print(imageURL)
        
        quantityPicker.dataSource = self
        quantityPicker.delegate = self
        // Do any additional setup after loading the view.
        
        itemDescriptionLabel.layer.borderWidth = 0.25
        itemDescriptionLabel.layer.cornerRadius = 5.0
        
        itemPriceLabel.layer.borderWidth = 0.25
        itemPriceLabel.layer.cornerRadius = 5.0
        
        
        
        selectedImage.layer.cornerRadius = 5.0
        
        
        
    }
    
    // In this function the current item is added to the cart
    @IBAction func addItemToCart(_ sender: UIButton) {
        //First save the item as a cartItem , then pass it to user defaults?
        
        //idea is to check if user defaults has an array,
        
        //then if it does , you want to add the cart item to the array of cart items
        
        var userID = (auth.currentUser?.uid)!
        
        let userDefaults = UserDefaults.standard
       
        //now s
        let imageString = selectedImage.image?.pngData()
        
        
        //this is item that your choosinf
        let currentItem = cartItem(vendorID: self.vendorID,
                                   itemImage: imageString, imageURL: imageURL, itemDescription: self.itemDescriptionLabel.text!, itemPrice: self.itemPriceText,quantity: self.selectedQuantity ?? "0")
        
        //make a
        //here check, if the current itrem ID
        var cartArray:cartArray = cartArray()
        if(userDefaults.valueExists(forKey: userID) == false) {
            //create an new array of type cart item, then add it
            cartArray.cartItems.append(currentItem)
            userDefaults.encodeCartData(data: cartArray.cartItems, key: userID)
        }  else {
            cartArray.cartItems = userDefaults.decodeCartData(key: userID)!
            cartArray.cartItems.append(currentItem)
            userDefaults.encodeCartData(data: cartArray.cartItems, key: userID)
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


extension ItemPriceDescriptionController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        //different sections of picker view
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        quanityItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(quanityItems[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedQuantity = self.quanityItems[row] as String
    }
    
    
    
}
