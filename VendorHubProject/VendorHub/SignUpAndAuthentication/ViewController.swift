//
//  ViewController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/5/22.
//

import UIKit
import Firebase


class ViewController: UIViewController {

        
    var ref = Database.database().reference()
    let db = Firestore.firestore()
    
    let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let auth = Auth.auth()

    @IBOutlet weak var vendorName: UITextField!
    @IBOutlet weak var vendorEmail: UITextField!
    @IBOutlet weak var vendorPassword: UITextField!
   @IBOutlet weak var vendorLogInButton: UIButton!
    @IBOutlet weak var VendorLoginEmail: UITextField!
    @IBOutlet weak var VendorLoginPassword: UITextField!
    @IBOutlet weak var VendorSignUpError: UILabel!
    @IBOutlet weak var LoginerrorLabel: UILabel!
    @IBOutlet weak var EmailError: UILabel!
    
    
    
    
    @IBOutlet weak var PasswordError: UILabel!
    
    var customerEmailTextVal = "";
    var customerPasswordVal = "";
    
    @IBOutlet weak var LocationPageButton: UIButton!
    
    //why the exclamation mark and other things too
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //should switch to the respective board that is begin shown, if the one shown
        
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if(auth.currentUser != nil) {
//            let storyboard = UIStoryboard(name: "vendorLocations", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "vendorItemsList") as UIViewController
//
//            self.present(controller, animated: true, completion: nil)
//        }
        
    }

    
    @IBAction func sendVendorInfoToFirebase(_ sender: UIButton) {
        //make a classs in swift herer, then
    
        
    //firestore data
        let vendorid = (auth.currentUser?.uid)!
        
     
        auth.createUser(withEmail: vendorEmail.text!, password: vendorPassword.text!) {
            (result,error) in
            if error != nil {
                self.VendorSignUpError.text = "User Already Exists With Those Credentials"
            } else {
                self.db.collection((result?.user.uid)!).document("Info").setData(["name":self.vendorName.text!,"email":self.vendorEmail.text!])
                self.performSegue(withIdentifier: "signUp", sender: self)
            }
            
        }
        
    }
    

    @IBAction func authenticateVendor(_ sender: UIButton) {
        
        auth.signIn(withEmail: VendorLoginEmail.text!, password: VendorLoginPassword.text!) { (result,error) in
            if error != nil {
                self.LoginerrorLabel.text = "Your email or password is incorrect"
                self.LoginerrorLabel.alpha = 1
            } else{
                
                //segue to go Dimitar's storyboard
               self.performSegue(withIdentifier: "VendorLocationsSegue", sender: self)
               
              
            }
            
         
        }
        
    }
    
    
    //sign out button will appear here hopefully!!
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
        //maybe here!!
    }
    
    //function that overrides segue. In this case, this segue goes to the vendor storybpard
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "VendorLocationsSegue" {
//            guard segue.destination is LocationDetailViewController else {return }
//        }
//        
//        
//    
//    }
    
}

