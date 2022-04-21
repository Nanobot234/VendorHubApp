//
//  LocationDetailViewController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 3/30/22.
//

import UIKit

class LocationDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "item: \(indexPath.item)"
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    var vendorLocation: VendorLocation!
    var vendorLocations: [VendorLocation] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        destination.vendorLocations = vendorLocations
    }
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        vendorLocations = source.vendorLocations
        vendorLocation = vendorLocations[source.selectedLocationIndex]
        //updateUserInterface()
    }

}
