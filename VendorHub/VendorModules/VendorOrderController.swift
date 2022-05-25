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
    
  //  var pastOrders = [Customer]
    let auth = Auth.auth()
    
    var vendorCoordinates = [Double]()
    var custDistances:[String:Int] = [:]  //distances for all the orders you have
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customerOrders = []
        FirestoreOps.shared.getOrderItemsforVendor(vendorID: auth.currentUser!.uid) { ordersdata in
            self.customerOrders = ordersdata
            DispatchQueue.main.async {
                self.orderTable.reloadData()
            }
            
        }
        
        
    }
    override func viewDidLoad() {
    
        //get the vendor coordinates from the database
        
        FirestoreOps.shared.getVendorLocationCoordinates(vendorID: auth.currentUser!.uid)
        { vendID in
            
            super.viewDidLoad()
            
            self.orderTable.dataSource = self
            self.orderTable.delegate = self
           
            print("Coordinates",vendID)
            self.vendorCoordinates = vendID
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.orderTable.reloadData()
        }
       
    }
    

    @IBAction func RefreshPressed(_ sender: Any) {
        self.orderTable.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func soldButtonPressed(_ sender: UIButton) {
        
        //here do an ale
        //if time away is greater than 3, ask if your show
        
        let soldAlert = UIAlertController(title: nil, message: "Are You sure you've completed this order?", preferredStyle: .alert)
        
        //do othet things
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            // replace data variable with your own data array
            let indexPath = IndexPath(row: sender.tag, section: 0)
            
            FirestoreOps.shared.setCompletedOrder(vendorID: (self.auth.currentUser?.uid)!, custID: self.customerOrders[sender.tag].CustomerID!, orderNum: self.customerOrders[sender.tag].orderNum, items: self.customerOrders[sender.tag].customerItems)
            
            FirestoreOps.shared.deleteOrderforUser(userID: (self.auth.currentUser?.uid)!, orderNum: self.customerOrders[sender.tag].orderNum, accountType: "vendor")
            FirestoreOps.shared.deleteOrderforUser(userID: (self.auth.currentUser?.uid)!, orderNum: self.customerOrders[sender.tag].orderNum, accountType: "customer")
            
            self.customerOrders.remove(at: sender.tag)
           self.orderTable.deleteRows(at: [indexPath], with: .fade)
            
        }
        
            soldAlert.addAction(yesAction)

        // cancel action
        soldAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(soldAlert, animated: true, completion: nil)
    }

    
    
    
}


extension VendorOrderController:UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.customerOrders.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        FirestoreOps.shared.checkCustomerDistance(vendLat: self.vendorCoordinates[1], vendLong: self.vendorCoordinates[0], customerID: self.customerOrders[indexPath.row].CustomerID!) { timeDistance in
            
            //setting each distance of custoemr in proper spot
            print("CustomerOrder",self.customerOrders[indexPath.row].CustomerID!)
            self.custDistances[self.customerOrders[indexPath.row].CustomerID!] = timeDistance
            
        }
        
        let cell = orderTable.dequeueReusableCell(withIdentifier: "order", for: indexPath) as! OrderNumandDistanceCell
    
        cell.orderNumLabel.text = "Order Num: " + self.customerOrders[indexPath.row].orderNum
        
        
        cell.distanceAwayLabel.text = String(self.custDistances[self.customerOrders[indexPath.row].CustomerID!] ?? 0) + " min away"
        
        cell.orderTotal.text = "$" +  String(self.customerOrders[indexPath.row].orderTotal!)
        
        
        cell.soldButton.backgroundColor = UIColor(red: 0.56, green: 0.93, blue: 0.56, alpha: 1.00)
        //hope to add distance label as well
        
        
        
        cell.soldButton.tag = indexPath.row
        cell.soldButton.addTarget(self, action: #selector(self.soldButtonPressed), for: .touchUpInside)
        
        let customerID = self.customerOrders[indexPath.row].CustomerID!
        
        
        
     
        
        
        return cell
        
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
