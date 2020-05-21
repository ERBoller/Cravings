//
//  SearchResultTableViewController.swift
//  Cravings
//
//  Created by ESBoller on 5/21/20.
//  Copyright © 2020 Enrico S Boller. All rights reserved.
//

import UIKit


class SearchResultTableViewController: UITableViewController {
    
    var restaurants: Array<NSDictionary>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let restaurants = restaurants {
            return restaurants.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let restaurants = restaurants {
            return restaurants[section].count
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchResultCell {
            if let restaurant = restaurants?[indexPath.row]{
                cell.populateRestaurantProperties(restaurantProperty: restaurant)
                
                return cell
            }
        }
        return UITableViewCell()
    }
}
