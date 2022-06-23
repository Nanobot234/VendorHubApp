//
//  CustomerOrderDetailsController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/18/22.
//

import UIKit

class CustomerOrderDetailsController: UIViewController {

    @IBOutlet weak var orderDetailsTable: UITableView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var myItems = [cartItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        orderDetailsTable.delegate = self
        orderDetailsTable.dataSource = self
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
    

}

extension CustomerOrderDetailsController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = orderDetailsTable.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! CustomerOrderDetailsCell
        
        let image = self.myItems[indexPath.row].imageURL
        
        cell.itemPrice.text = "Price" + self.myItems[indexPath.row].itemPrice
        
        cell.itemImage.setImage(image)
        
        return cell
        
        
    }
    
    
    
    
}
