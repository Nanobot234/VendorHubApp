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
      
        let currentuser = (auth.currentUser?.uid)!
        
        uploadImage()  //upload image first
        
        
        db.collection("Vendor").document(currentuser).setData(["ItemPrice":itemPrice.text!,"Item Description":itemDescription.text!,"Image":imageLocation], merge: true)
        //show previous again
//        let storyboard = UIStoryboard(name: "vendorLocations", bundle: nil)
//               let targetVC = storyboard.instantiateViewController(identifier: "vendorItemsListTable")
//        show(targetVC, sender: self)
        if(itemImage.image != nil){
        navigationController?.popViewController(animated: true)
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

    func uploadImage() {
        storage.child(""+auth.currentUser!.uid + "/image.png").putData((itemImage.image?.pngData())!, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
        })
            storage.child(""+auth.currentUser!.uid + "/image.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                self.imageLocation = url.absoluteString
                UserDefaults.standard.set(self.imageLocation, forKey: "url")
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
