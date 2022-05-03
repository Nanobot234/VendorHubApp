//
//  ItemsDescriptionController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/13/22.
//

import UIKit
import Firebase
import Photos
import FirebaseStorage
import FirebaseAuth


//class for item descriptions, when adding a new item
class ItemsDescriptionController: UIViewController {

    let db = Firestore.firestore()
    let auth = Auth.auth()
    
 
    
    @IBOutlet weak var itemImage: UIImageView!
    
    
    
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDescription: UITextView!
    
    private let storage = Storage.storage().reference()
    
    
   
    
    var imageLocation = ""
    let ImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ImagePickerController.delegate = self
        ImagePickerController.sourceType = .photoLibrary
        ImagePickerController.allowsEditing = true
    }
    
    
    @IBAction func uploadVendorItems(_ sender: Any) {
      
      
        
          //upload image first
        //if successful upload and have image then will go to the next view
        self.uploadImageandDetails { result in
            if result && (self.itemImage.image != nil) {
                self.navigationController?.popViewController(animated: true)
            }
        }
      
        
        //from here update the table viw right, omg
        
    //https://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
        //updating ity here
    }
    
    //when you tap the upload button
    @IBAction func ChooseImage() {
       
        present(ImagePickerController, animated: true)
    }
   //now get the image

    
    func uploadImageandDetails(completed:@escaping (Bool) -> Void) {
        
        let currentuser = (auth.currentUser?.uid)!
        let imageId = UUID()
        
        storage.child(""+auth.currentUser!.uid + "/" + imageId.uuidString +  ".png").putData((itemImage.image?.pngData())!, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.sendtoFirestore(imageId) { val in
                if val {
                    completed(true)
                }
                else {
                    completed(false)
                }
            }
        })
          
        
      
    }

    
    func sendtoFirestore(_ imageId: UUID, completed:@escaping (Bool) -> Void) {
        
        let currentuser = (auth.currentUser?.uid)!
        storage.child(""+auth.currentUser!.uid + "/" +  imageId.uuidString + ".png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                   
                    return
                }
                self.imageLocation = url.absoluteString
                self.db.collection("Vendor").document(currentuser).collection("Items").addDocument(data:["ItemPrice":self.itemPrice.text!,"ItemDescription":self.itemDescription.text!,"Image":self.imageLocation])
               // print(self.imageLocation)
                
                completed(true)
               
        })
        
    }
}



extension ItemsDescriptionController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    //called when you choose the item I guess
    
    //put in url
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
       
        //put image here
       
        itemImage.image = UIImage(data: imageData)
        picker.dismiss(animated: true,completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
   
   
}
