//
//  VendorItemsController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/5/22.
//

import UIKit
import Firebase
import FirebaseAuth
class VendorItemsController: UIViewController {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    
    @IBOutlet weak var table: UITableView!
    
 
    //JOhn tutorial saving class to firestir
    
    //strill watch video
    
    override func viewDidLoad() {
       
        
      //  if(auth.currentUser != nil){Progress}
        // Do any additional setup after loading the view.
        //no cnnection to table view omgggg
        table.delegate = self
        table.dataSource = self
        
        
    }
    
 
    
        //idea is to have   table view, with all the list of items,
    /*
    // MARK: - Navigation

        //make new vew contgroller
     
     //this here wil go to storyboard
     func switchStoryboard() {
         let storyboard = UIStoryboard(name: "NameOfStoryboard", bundle: nil)
         let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerName") as UIViewController

         self.present(controller, animated: true, completion: nil)
     }
     
     funv
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //trying to have it then when the ui loads, if have current user then just swiutch to this

}

extension VendorItemsController:UITableViewDelegate,UITableViewDataSource {
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
    }
    
    
    
}

