//
//  CustomerCartController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/4/22.
//

import UIKit

class CustomerCartController: UIViewController {

    
    var CustomerCart:cartArray = cartArray() //the cart using for tableView
    //in this classwill
    @IBOutlet weak var cartTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        //show something if you have cart data only
        
        if(userDefaults.valueExists(forKey: "cartArray") == true) {
        CustomerCart.cartItems = userDefaults.decodeCartData()!
            self.cartTable.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cartTable.delegate = self
        cartTable.dataSource = self
        
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
        let vendorName = FirestoreOps.getVendorName(vendorID: vendorID)
        print(vendorName)
        cell.StoreName?.text = vendorName
        
        
        //image
        let imageData = CustomerCart.cartItems[indexPath.row].itemImage
        
        cell.itemImage.image = UIImage(data: imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomerCart.cartItems.count
    }
    
    
}
