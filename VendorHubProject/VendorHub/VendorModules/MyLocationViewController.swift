//
//  MyLocationViewController.swift
//  VendorHub
//
//  Created by Dimitar Krastev on 5/18/22.
//

import UIKit
import GooglePlaces

class MyLocationViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var edditBarButton: UIBarButtonItem!
    
    
    
    var vendorLocations: [VendorLocation] = []
    var selectedLocationIndex = 0
    var vendorLocation: VendorLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! MyCurrentLocationViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.vendorLocation = vendorLocations[selectedIndexPath.row]
            
            
            selectedLocationIndex = tableView.indexPathForSelectedRow!.row
            // vendorLocations[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        
        autocompleteController.delegate = self
        
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    

    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
        
    }
    
}


extension MyLocationViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendorLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = vendorLocations[indexPath.row].address
        cell.detailTextLabel?.text = "Lat: \(vendorLocations[indexPath.row].latitude), Long::\(vendorLocations[indexPath.row].longitude)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            vendorLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        let itemToMove = vendorLocations[sourceIndexPath.row]
        vendorLocations.remove(at: sourceIndexPath.row)
        vendorLocations.insert(itemToMove, at: destinationIndexPath.row)
        
    }
    
}

extension MyLocationViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        print("Place name: \(String(describing: place.name))")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")

        
        let newLocation = VendorLocation(address: place.formattedAddress ?? "unknown place", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        vendorLocations.append(newLocation)
        tableView.reloadData()
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


