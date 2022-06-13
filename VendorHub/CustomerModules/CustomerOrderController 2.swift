//
//  CusrtomerOrderController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/18/22.
//

import UIKit
import Firebase

class CustomerOrderController: UIViewController {

    @IBOutlet weak var customerorderTable: UITableView!
    
    var myOrders = [Customer]()
    
    let auth = Auth.auth()
    
    let mystoryboard =  UIStoryboard(name:"CustomerUserFlow" , bundle: nil)
    
    var customerCoordinates:[Double] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.myOrders = []
        
        FirestoreOps.shared.getOrderItemsforCustomer(customerID: auth.currentUser!.uid) { ordersdata in
            print(ordersdata)
            self.myOrders = []
            self.myOrders = ordersdata
            DispatchQueue.main.async {
                self.customerorderTable.reloadData()
            }
        }
    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customerorderTable.dataSource = self
        customerorderTable.delegate = self
        
        FirestoreOps.shared.getCustomerLocationCoordinates(customerID: (auth.currentUser?.uid)!) { custID in
            self.customerCoordinates = custID
        }
    }
    

  //function to send the vendors coordinates to google maps to alloew for navigation
        
    //will use tag to see the correct vendor ID for the order
        //then pass it to google maps
    //
    
    @objc func directionButtonPressed(_ sender:UIButton) {
        
        let selectedVendor = self.myOrders[sender.tag].vendorID!
        
        FirestoreOps.shared.getVendorLocationCoordinates(vendorID: selectedVendor) { vendID in
            if(UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.open(URL(string:  "comgooglemaps://?saddr=&daddr=\(vendID[1]),\(vendID[0])&directionsmode=walking")!)
            } else {
                let url = "http://maps.apple.com/maps?saddr=\(self.customerCoordinates[1]),\(self.customerCoordinates[0])&daddr=\(vendID[1]),\(vendID[0])"
                UIApplication.shared.open(URL(string: url)!)
            }
                }
        
        
}
    
}

extension CustomerOrderController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.myOrders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerorderTable.dequeueReusableCell(withIdentifier: "custOrder", for: indexPath) as! CustomerOrderStoreCell
        
        cell.customerorderNum.text = "Order Num" + self.myOrders[indexPath.row].orderNum
        
        cell.vendorStore.text = self.myOrders[indexPath.row].vendorStoreName
        
        cell.getVendorDirections.tag = indexPath.row
        
        cell.getVendorDirections.addTarget(self, action: #selector(self.directionButtonPressed), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let customerorderDetailsVC = mystoryboard.instantiateViewController(withIdentifier: "customerOrderDetails") as! CustomerOrderDetailsController
        
        customerorderDetailsVC.myItems = self.myOrders[indexPath.row].customerItems
        
        navigationController?.present(customerorderDetailsVC, animated: true, completion: nil)
        
        
        
    }
    
    
    
}
