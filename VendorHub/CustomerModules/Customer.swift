//
//  Customer.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/13/22.
//


//ignore this class for now, I have not used it as of now




import Foundation
import FirebaseAuth

struct cartItem: Codable {

    var vendorID:String?
    var CustomerID: String?
    var itemImage:Data?
    var imageURL:String? //the firebase image you save
    var itemDescription:String
    var itemPrice:String
    var itemID:String?//this will the itemID in the vendor storage
    var quantity:String?
}

struct cartArray: Codable {
    var cartItems: [cartItem] = Array()
    
}

//this class willl be used to save the data recieved for the vendor for the order

//will get multiple arrays representing the different items for the customer.
struct Customer {
    
    var vendorID:String?
    var orderNum:String
    var CustomerID:String?
    var vendorStoreName: String?
    var location:String? //should be used to determine distance aeay
    var customerItems = [cartItem]()
    var orderTotal:Int?
    //input is an dictionary some of them will be array,
    init(input:[String:Any], CustorderNum:String) {
        
        
        orderNum = CustorderNum
        print("Current Order Num",orderNum)
        //now set custoemr items as the array
        //will get an array with each as
        if(input["VendorName"] != nil) {
            vendorStoreName = input["VendorName"] as? String
        }
        
        CustomerID = input["customerID"] as? String
        
        vendorID = input["VendorID"] as? String
    
        orderTotal = input["orderTotal"] as? Int
        
        //order total here!
        for (_, value) in input {
            if let array = value as? NSArray {
                //convert the array to data for the image
               // let data = Data((array[2] as! String).utf8)
                print("UserOorder",array[1])
            //    print("quanitt",array[3])
                
                let item = cartItem(vendorID: nil, CustomerID: nil, imageURL: array[2] as? String, itemDescription: array[1] as! String, itemPrice: array[0] as! String, itemID: nil,quantity: array[3] as? String)
                //saving all the items for the customer
                customerItems.append(item)
            }
        }
            //loop through input get the array, then create a cart item with the array elements
    }
    
}
