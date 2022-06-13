//
//  VendorOrderDetailsController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/13/22.
//

import UIKit

class VendorOrderDetailsController: UIViewController {

    
    
    @IBOutlet weak var orderdetailsTable: UITableView!
    
 
    
    var orderItems = [cartItem]() //then will pass the item here
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        orderdetailsTable.dataSource = self
        orderdetailsTable.delegate = self
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    
    
}

extension VendorOrderDetailsController: UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.orderItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = orderdetailsTable.dequeueReusableCell(withIdentifier: "orderinfo", for: indexPath) as! OrderDetailsCell
        
       
        let image = self.orderItems[indexPath.row].imageURL
        
        
        cell.itemImage.setImage(image)
        
        cell.itemQuantity.text = "Quantity " + self.orderItems[indexPath.row].quantity!
        return cell
    }
    
    
    
}
