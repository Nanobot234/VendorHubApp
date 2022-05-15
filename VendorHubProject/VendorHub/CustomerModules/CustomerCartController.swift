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
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        //show something if you have cart data only
        
        let userID = (auth.currentUser?.uid)!
        
        
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
    
    @IBAction func placeOrder(_ sender: Any) {
        
        //loop through cart , then make an order depending on the vendor,
        //order will have order number, then items as well, as an arrsy of dic
       // var orderarr = [cartItem]()
        
        FirestoreOps.setOrderItem(customerID: auth.currentUser!.uid,iteminfo: CustomerCart.cartItems) { finished in
            if finished {
                print("Sent Items to Vendor")
            }
        }
               
                
    }
    
    
    
    //function to get the vendor items from userDefaulkts

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CustomerCartController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "cartItem") as! CartItemCell
        
        cell.itemDescription?.text = CustomerCart.cartItems[indexPath.row].itemDescription
        
        cell.itemPrice?.text = CustomerCart.cartItems[indexPath.row].itemPrice
        
        
        let vendorID = CustomerCart.cartItems[indexPath.row].vendorID
      //  let vendorName = FirestoreOps.getVendorName(vendorID: vendorID)
       // print(vendorName)
       // cell.StoreName?.text = vendorName
        
        
        let imageData = CustomerCart.cartItems[indexPath.row].itemImage
        
        //this image is created from the image that you set the collectionView to
        cell.itemImage.image = UIImage(data: imageData!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomerCart.cartItems.count
    }
    
    
}
