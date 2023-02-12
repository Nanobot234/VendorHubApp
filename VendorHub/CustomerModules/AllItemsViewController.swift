//
//  AllItemsViewController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 11/18/22.
//


import UIKit
import Foundation

class AllVendorItemsViewController: UIViewController {

    var vendorItems: [Model] = [] //putting in the explicit type
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(vendorItems.isEmpty == nil) {
            print("Has Value")
        }
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

extension AllVendorItemsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //make the collection View here, and then adjust it
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vendorItems.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VendorAllItemsCollectionViewCell
        
        cell.VendorItemImage.setImage(vendorItems[indexPath.row].imageName)
        
        return cell

    }
}
    
    

