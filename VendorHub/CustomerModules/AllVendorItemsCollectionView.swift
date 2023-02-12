//
//  AllItemsViewController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 11/18/22.
//


import UIKit
import Foundation

class AllVendorItemsCollectionView: UICollectionView {

    var vendorItems = [Model]()//putting in the explicit type
    var classVendorItems: [Model] = []
    
    
        // Do any additional setup after loading the view.]
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        self.dataSource = self
    }
    
        
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        
    //now need to 



extension AllVendorItemsCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    //make the collection View here, and then adjust it
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classVendorItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell //need to cast to the collectioView already created, not my ow 
        
        cell.myImage.setImage(classVendorItems[indexPath.row].imageName)
        
        return cell

    }
}
    
    

