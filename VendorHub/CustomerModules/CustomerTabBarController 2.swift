//
//  CustomerTabBarController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 5/2/22.
//

import UIKit

class CustomerTabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

  
}
