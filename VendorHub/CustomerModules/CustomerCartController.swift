//
//  CustomerCartController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/4/22.
//

import UIKit
import Firebase

class CustomerCartController: UIViewController {

    
    var CustomerCart:cartArray = cartArray() //the cart using for tableView
    let auth = Auth.auth()
    //in this classwill
    @IBOutlet weak var cartTable: UITableView!
    let userDefaults = UserDefaults.standard
    var userID = ""
    @IBOutlet weak var PlaceOrderButton: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        //show something if you have cart data only
        
      
         userID = (auth.currentUser?.uid)!
        if(userDefaults.valueExists(forKey: userID) == true) {
            CustomerCart.cartItems = userDefaults.decodeCartData(key: userID)!
            self.cartTable.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cartTable.delegate = self
        cartTable.dataSource = self
        
    }
    
    
    @IBAction func CartEditPressed(_ sender: UIBarButtonItem) {
      
    
        if cartTable.isEditing {
                   cartTable.setEditing(false, animated: true)
                   sender.title = "Edit"
                   PlaceOrderButton.isEnabled = true
               } else {
                   cartTable.setEditing(true, animated: true)
                   sender.title = "Done"
                   PlaceOrderButton.isEnabled = false
               }
    }
    
    func deleteItemCheck(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this item from your cart", preferredStyle: .alert)

        let userDefaults = UserDefaults.standard
        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            // replace data variable with your own data array
            userDefaults.deleteItembyIndex(index: indexPath.row, userID:(self.auth.currentUser?.uid)!)
            self.CustomerCart.cartItems = userDefaults.decodeCartData(key: (self.auth.currentUser?.uid)!)!
            self.cartTable.deleteRows(at: [indexPath], with: .fade)
          
            
        }

        alert.addAction(yesAction)

        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        
        //loop through cart , then make an order depending on the vendor,
        //order will have order number, then items as well, as an arrsy of dic
       // var orderarr = [cartItem]()
        
        FirestoreOps.shared.setOrderItem(customerID: auth.currentUser!.uid,iteminfo: CustomerCart.cartItems) { finished in
            if finished {
                print("Sent Items to Vendor")
                
                //write an empty array back into the userDefaults
                self.CustomerCart.cartItems = self.userDefaults.decodeCartData(key: self.userID)!
                self.CustomerCart.cartItems = []
                self.userDefaults.encodeCartData(data: self.CustomerCart.cartItems, key: self.userID)
                self.cartTable.reloadData()
            }
        }
               
                
    }
    
    
}

extension CustomerCartController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "cartItem") as! CartItemCell
        
        cell.itemDescription?.text = CustomerCart.cartItems[indexPath.row].itemDescription
        
        cell.itemPrice?.text = "$" + CustomerCart.cartItems[indexPath.row].itemPrice
        
        cell.QuanityLabel.text = "Quantity: " + CustomerCart.cartItems[indexPath.row].quantity!
        
        
        let vendorID = CustomerCart.cartItems[indexPath.row].vendorID!
        
        print(vendorID)
        
        FirestoreOps.shared.getVendorName(vendorID: vendorID) { name in
            cell.StoreName.text = name
        }
        
      //  let vendorName = FirestoreOps.getVendorName(vendorID: vendorID)
       // print(vendorName)
       // cell.StoreName?.text = vendorName
        
        
        let imageData = CustomerCart.cartItems[indexPath.row].itemImage
        
        //this image is created from the image that you set the collectionView to
        cell.itemImage.image = UIImage(data:imageData!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomerCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItemCheck(indexPath: indexPath)
        }
       
    }
    
}
