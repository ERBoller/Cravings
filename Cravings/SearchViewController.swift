//
//  SearchViewController.swift
//  Cravings
//
//  Created by ESBoller on 5/21/20.
//  Copyright © 2020 Enrico S Boller. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var restoName: UITextField!
    @IBOutlet weak var restoAddress: UITextField!
    @IBOutlet weak var restoCuisine: UITextField!
    @IBOutlet weak var restoErrorMessage: UILabel!
    @IBOutlet weak var restoSearchButton: UIButton! {
        didSet {
            restoSearchButton.titleLabel?.text = "Search"
            restoSearchButton.backgroundColor = .clear
            restoSearchButton.layer.cornerRadius = restoSearchButton.bounds.height / 2
            restoSearchButton.layer.borderWidth = 1
            restoSearchButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    fileprivate let header = ["Authorization":"Bearer Qm0LyS4Ocj6ItddG5xY3JoCDAO2wmdoGxnVousrUI9RIoo8aM5zodFHLpS1rMs96iK7V2Sh7dCZWKazqp31k67W67wWRsF29-4qkz9nY2ladK7agzX-HuR0iA-bEXnYx"]
    fileprivate let yelpBusinessSearch = "https://api.yelp.com/v3/businesses/search"
    fileprivate var restaurantResults: Array<NSDictionary>?
    var locationManager: CLLocationManager?
    var deviceLatitude: CLLocationDegrees?
    var deviceLongitude: CLLocationDegrees?
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        restoErrorMessage.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SearchResultTableViewController
        {
            let vc = segue.destination as? SearchResultTableViewController
            vc?.restaurants = restaurantResults
        }
    }
    
    // MARK: IBAction Methods
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard isQueryEntryValid() else {
            return
        }
        
        
        var params = [String():String()]
        params.popFirst()
        
        if let restoNameField = restoName.text,
            let restoAddressField = restoAddress.text,
            let restoCuisineField = restoCuisine.text {
            
            if restoNameField.count > 0 && restoCuisineField.count > 0 {
                params["term"] = "\(restoNameField),\(restoCuisineField)"
            } else if restoNameField.count > 0 && restoCuisineField.count == 0 {
                params["term"] = "\(restoNameField)"
            } else if restoNameField.count == 0 && restoCuisineField.count > 0 {
                params["term"] = "\(restoCuisineField)"
            }
            
            if !restoAddressField.isEmpty {
                params["location"] = restoAddressField
            }
            
            if let latitude = deviceLatitude,
                let longitude = deviceLongitude,
                restoAddressField.isEmpty {
                params["latitude"] = String(latitude)
                params["longitude"] = String(longitude)
            }
            
            proceedWithSearch(parameters: params)
        }
    }
    
    // MARK: Helper Methods
    
    private func isQueryEntryValid() -> Bool {
        if let restoNameField = restoName.text,
            let restoAddressField = restoAddress.text,
            let restoCuisineField = restoCuisine.text {
            let queryFieldsContainsValue = [restoNameField.count > 0, restoAddressField.count > 0, restoCuisineField.count > 0]
            restoErrorMessage.isHidden = queryFieldsContainsValue.contains(true)
            
            return queryFieldsContainsValue.contains(true)
        }
        
        restoErrorMessage.isHidden = true
        return true
    }
    
    private func proceedWithSearch(parameters: [String:String]) {
        let request = Alamofire.request(yelpBusinessSearch, method: .get, parameters: parameters, headers: header)
        request.responseJSON { (data) in
            if let dataObject = data.data {
                if let dataResponse = try? JSONSerialization.jsonObject(with: dataObject, options: []) as? Dictionary<String, Any> {
                    if let businesses = dataResponse["businesses"] as? Array<NSDictionary> {
                        self.restaurantResults = businesses
                        self.performSegue(withIdentifier: "searchResultSegue", sender: nil)
                    }
                }
            }
        }
    }
}

extension SearchViewController {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        deviceLatitude = locValue.latitude
        deviceLongitude = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
