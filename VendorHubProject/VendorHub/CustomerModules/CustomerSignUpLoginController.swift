//
//  CustomerSignUpLoginController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/29/22.
//

import UIKit
import Firebase
import FirebaseFirestore


class CustomerSignUpLoginController: UIViewController {

    
    var myref = Database.database().reference()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    
    let currStoryboard = UIStoryboard(name: "Main", bundle: nil)
    @IBOutlet weak var customerName: UITextField!
    
    @IBOutlet weak var customerEmail: UITextField!
    
    @IBOutlet weak var customerPassword: UITextField!
    @IBOutlet weak var confirmCustomerPassword: UITextField!
    
    @IBOutlet weak var createCustomerAccountButton: UIButton!
    
    @IBOutlet weak var customerLogInEmail: UITextField!
    
    @IBOutlet weak var customerLoginPassword: UITextField!
    
    @IBOutlet weak var EmailError: UILabel!
    @IBOutlet weak var ConfirmPasswordError: UILabel!
    
    @IBOutlet weak var CreateUserError: UILabel!
    
    @IBOutlet weak var LogInUserError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    //initialControl()
    }
    
    func initialControl() {
        createCustomerAccountButton.isEnabled = false
        EmailError.isHidden = false
        ConfirmPasswordError.isHidden = false
        
        
    }
    
    @IBAction func emailFieldValidation(_ sender: Any) {
        
        
        if let email = customerEmail.text
        {
            if let emailerrorMessage = invalidEmail(email) {
                EmailError.text = emailerrorMessage
                EmailError.isHidden = false
            }
            else {
                EmailError.isHidden = true
            }
        }
        
        checkForValidForm()
        
    }
    
    //check if confirm password
    func invalidEmail(_ value:String) -> String? {
        
        // let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          //      let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if (value.contains("@") == false)
                {
                    return "Invalid Email Address"
        }
        
        return nil
    }
    
    
    @IBAction func confirmPasswordValidation(_ sender: Any) {
        
        if(customerPassword.text == confirmCustomerPassword.text) {
            ConfirmPasswordError.isHidden = true
        } else {
            ConfirmPasswordError.text = "Passwords Do Not Match"
            ConfirmPasswordError.isHidden = false
        }
        checkForValidForm()
    }
 
    
    func checkForValidForm() {
        
        if EmailError.isHidden && ConfirmPasswordError.isHidden {
            createCustomerAccountButton.isEnabled = true
        }
    }
    
    
    @IBAction func createCustomerAccount(_ sender: Any) {
        
        if(createCustomerAccountButton.isEnabled == true) {
            auth.createUser(withEmail: customerEmail.text!, password: customerPassword.text!) { [self]
                (result,error) in
                if error != nil {
                    self.CreateUserError.text = "User Already Exists With Those Credentials"
                    print("Wrong")
                } else {
                    self.db.collection("Customers").document((result?.user.uid)!).setData(["Name":self.customerName.text!,"Longitude":0.0, "Latitude":0.0,"accountType":"customer"], merge: true)
                    
                    self.performSegue(withIdentifier: "accountCreatedSegue", sender: self)
                    
                    
                }
                
            }
        }
    }
    
    
    //should check the account type to see if its correct
    @IBAction func LogInCustomer(_ sender: Any) {
        
        //get the customer account type here!!
        auth.signIn(withEmail: customerLogInEmail.text!, password: customerLoginPassword.text!) { (result,error) in
            if error != nil {
                self.LogInUserError.text = "Incoreect Login Credentials"
            } else{
                //segue to go Dimitar's storyboard
               self.performSegue(withIdentifier: "customerHomepageSegue", sender: self)
    }
        }
    }
          
          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "customerHomepageSegue" {
                    guard segue.destination is CustomerHomePageController else {return }
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

}
