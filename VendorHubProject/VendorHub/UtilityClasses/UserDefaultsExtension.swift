//
//  UserDefaultsExtension.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/5/22.
//

import Foundation

//user defaults

extension UserDefaults {
    
    //check if a value exists
    func valueExists(forKey key: String) -> Bool {
            return object(forKey: key) != nil
        }
    

    func encodeCartData(data:[cartItem],key:String) {
        
        do {
            let encoder = JSONEncoder()
            
            let newdata = try encoder.encode(data)
         
            UserDefaults.standard.set(newdata, forKey: key)
        } catch {
            print("Unable to Encode cart array (\(error))")
        }
    }
    
    //get the cart item stored in local storage
    func decodeCartData(key:String) -> [cartItem]? {
        if let data = UserDefaults.standard.data(forKey: key){
        
        do {
               // Create JSON Decoder
               let decoder = JSONDecoder()

               // Decode Note
            let cartData = try decoder.decode([cartItem].self, from: data)
                
            return cartData
            
           } catch {
               print("Unable to Decode Note (\(error))")
           }
    }
        return nil
    }
}
