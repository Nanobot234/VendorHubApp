//
//  MyCurrentLocationViewController.swift
//  VendorHub
//
//  Created by Dimitar Krastev on 5/18/22.
//

import UIKit
import GooglePlaces
import GoogleMaps
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class MyCurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    var vendorLocation: VendorLocation!
    var vendorLocations: [VendorLocation] = []
    var vendorAddress: String!
    
    
    //retrurn zer
    var lat = VendorLocation().latitude.self
    var long = VendorLocation().longitude.self

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vendorLocation == nil{
            vendorLocation = VendorLocation()
            
        }
        
        updateUserInterface()

        
    }
    
    func updateUserInterface () {
        addressTextField.text = vendorLocation.address
        
    }
    
    func updateFomInterface() {
        
        vendorLocation.address = addressTextField.text ?? "No address"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MyLocationViewController
        destination.vendorLocations = vendorLocations
        
        
    }
    
    
    @IBAction func saveLocationButtonPressed(_ sender: UIButton) {
        updateFomInterface()
        
        if let currentuser = (auth.currentUser?.uid), let vendorName = nameTextField.text, let vendorAddress = addressTextField.text {

            db.collection("Vendor").document(currentuser).setData(["address": vendorAddress, "latiude": vendorLocation.latitude, "longitude": vendorLocation.longitude], merge: true)
            
        
    }
    
    }


}
