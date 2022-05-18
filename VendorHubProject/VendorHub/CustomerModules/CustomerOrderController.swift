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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.myOrders = []
        
        FirestoreOps.getOrderItemsforCustomer(customerID: auth.currentUser!.uid) { ordersdata in
            print(ordersdata)
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

extension CustomerOrderController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.myOrders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerorderTable.dequeueReusableCell(withIdentifier: "custOrder", for: indexPath) as! CustomerOrderStoreCell
        
        cell.customerorderNum.text = "Order Num" + self.myOrders[indexPath.row].orderNum
        
        cell.vendorStore.text = self.myOrders[indexPath.row].vendorStoreName
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let customerorderDetailsVC = mystoryboard.instantiateViewController(withIdentifier: "customerOrderDetails") as! CustomerOrderDetailsController
        
        customerorderDetailsVC.myItems = self.myOrders[indexPath.row].customerItems
        
        navigationController?.present(customerorderDetailsVC, animated: true, completion: nil)
        
        
        
    }
    
    
    
}
