//
//  TableViewCell.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/27/22.
//

import Foundation

import UIKit


class CollectionTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //the identifier given to the item ins storyboard!!
    static let identifier = "CollectionTableViewCell"
    
    
    var tableCellIndexPath = 0
 
    
    @IBOutlet weak var mycollectionView: UICollectionView!
    
    @IBOutlet weak var AllItemsButton: allItemsButton!
    
    //images will go here to load
    var vendorItems = [Model]()
    
    var cellDelegate: CollectionViewCellDelegate?
    
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }

        //this sets up the Ui from the nip class!!
    override func awakeFromNib() {
        super.awakeFromNib() //get an excplkanation for thi
        
        //the register connects the colleciton View object with the required type
        
        mycollectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.indentifier)
        
        mycollectionView.delegate = self
        mycollectionView.dataSource = self
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //functtion that confiugues the vendorItmes arraty, with the model(data) array passed  into it!
    func configure(with models: [Model]) {
        self.vendorItems = models
        mycollectionView.reloadData() //incase of problems?
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vendorItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.indentifier, for: indexPath) as! CollectionViewCell
        
        cell.tablecellindex = indexPath.row
        cell.configure(with: vendorItems[indexPath.row])
        return cell
    }
        
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        self.tableCellIndexPath = indexPath.row //this is actually, the collection View position your at
        print("Index",indexPath.section)
        print("Index row",indexPath.row)
        
     
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self,sectionNum: indexPath.section)
       
        //make the
        }
    
    
    

      //  cell.myImage.addGestureRecognizer(tapGesture)
        
        
        
    
    //the size of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    //probabbly will perform the segue here!!
    


    
        
    
    //create  table vieww cell
}

protocol CollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: CollectionViewCell?, index: Int,didTappedInTableViewCell: CollectionTableViewCell,sectionNum: Int)
    
}

