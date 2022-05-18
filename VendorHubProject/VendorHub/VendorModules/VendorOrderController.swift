//
//  VendorOrderController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/10/22.
//

import UIKit
import FirebaseAuth
import Firebase
class VendorOrderController: UIViewController {

    @IBOutlet weak var orderTable: UITableView! //table with orders
    
    @IBOutlet weak var orderNumLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    var customerOrders = [Customer]() //the customers you will store
    
    let vendorBoard =  UIStoryboard(name:"vendorLocations" , bundle: nil)
    
    let auth = Auth.auth()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customerOrders = []
        FirestoreOps.getOrderItemsforVendor(vendorID: auth.currentUser!.uid) { ordersdata in
            self.customerOrders = ordersdata
            DispatchQueue.main.async {
                self.orderTable.reloadData()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTable.dataSource = self
        orderTable.delegate = self

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


extension VendorOrderController:UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.customerOrders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTable.dequeueReusableCell(withIdentifier: "order", for: indexPath) as! OrderNumandDistanceCell
        
        
        cell.orderNumLabel.text = "Order Num" + self.customerOrders[indexPath.row].orderNum
        
        //hope to add distance label as well
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //here instantiate the other view controller and pass the selected customer to it!!
        let orderDetailsVC = vendorBoard.instantiateViewController(withIdentifier: "customerorderItems") as! VendorOrderDetailsController
        //then will work form there
        
        //gettign the items for the customer that you selected
        orderDetailsVC.orderItems = self.customerOrders[indexPath.row].customerItems
            //need to get the order 
        
      
        
        navigationController?.present(orderDetailsVC, animated: true, completion: nil)
    }

}
