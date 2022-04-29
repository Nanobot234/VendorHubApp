//
//  ProfileSettingsController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/28/22.
//

import UIKit
import FirebaseAuth
class ProfileSettingsController: UIViewController {

    let auth = Auth.auth()
    
    
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
        try auth.signOut()
        } catch let err {
            print(err)
        }
        performSegue(withIdentifier: "unwindtoLogin", sender: self)
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
