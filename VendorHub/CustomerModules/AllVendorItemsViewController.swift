//
//  AllVendorItemsViewController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 1/2/23.
//

import UIKit

class AllVendorItemsViewController: UIViewController {

    
    var vendorItems = [Model]()//putting in the explicit type
    var classVendorItems: [Model] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        classVendorItems = vendorItems
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
        return classVendorItems.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.myImage.setImage(classVendorItems[indexPath.row].imageName)
        
        return cell

    }
}


