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
    
    let ImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ImagePickerController.delegate = self
        ImagePickerController.sourceType = .photoLibrary
        ImagePickerController.allowsEditing = true
       
    }
    
    @IBAction func uploadVendorItems(_ sender: Any) {
      
        let currentuser = (auth.currentUser?.uid)!
        
        db.collection("Vendor").document(currentuser).setData(["ItemPrice":itemPrice.text!,"Item Description":itemDescription.text!], merge: true)
        //show previous again
//        let storyboard = UIStoryboard(name: "vendorLocations", bundle: nil)
//               let targetVC = storyboard.instantiateViewController(identifier: "vendorItemsListTable")
//        show(targetVC, sender: self)
        
        navigationController?.popViewController(animated: true)
    }
    
    //when you tap the upload button
    @IBAction func ChooseImage() {
       
        present(ImagePickerController, animated: true)
    }
   //now get the image

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        //storage.putData(imageData, metadata: nil, completion: <#T##((StorageMetadata?, Error?) -> Void)?##((StorageMetadata?, Error?) -> Void)?##(StorageMetadata?, Error?) -> Void#>)
        itemImage.image = UIImage(data: imageData)
        picker.dismiss(animated: true,completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
   
   
}
