//
//  SearchResultCell.swift
//  Cravings
//
//  Created by ESBoller on 5/21/20.
//  Copyright © 2020 Enrico S Boller. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var OpenOrClosedIndicator: UIImageView!{
        didSet {
            if let isEstablishmentOpen = restaurantEntity?["is_closed"] as? String {
                if isEstablishmentOpen.lowercased().contains("no") {
                    OpenOrClosedIndicator.image = UIImage(imageLiteralResourceName: "smallcircle.circle.fill")
                    OpenOrClosedIndicator.tintColor = UIColor.green
                } else {
                    OpenOrClosedIndicator.image = UIImage(imageLiteralResourceName: "smallcircle.circle.fill")
                    OpenOrClosedIndicator.tintColor = UIColor.black
                }
            }
        }
    }
    @IBOutlet weak var restaurantImage: UIImageView!{
        didSet {
            if let restaurantImageURL = restaurantEntity?["image_url"] as? String {
                restaurantImage.imageFromUrl(urlString: restaurantImageURL)
            }
        }
    }
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantCategory: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantPhone: UILabel!
    @IBOutlet weak var restaurantRatings: UILabel!
    @IBOutlet weak var restaurantDeals: UILabel!
    var restaurantEntity: NSDictionary?
    
    func populateRestaurantProperties(restaurantProperty: NSDictionary) {
        restaurantEntity = restaurantProperty
        restaurantName.text = restaurantProperty["name"] as? String
        if let restaurantCategoryObject = restaurantProperty["categories"] as? [[String:String]] {
            for category in restaurantCategoryObject {
                if let restoCategory = restaurantCategory.text,
                    let titleCategory = category["title"] {
                    restaurantCategory.text = restoCategory + titleCategory + " "
                }
            }
        }
        
        if let _ = OpenOrClosedIndicator.image,
            let isEstablishmentClosed = restaurantProperty["is_closed"] as? Bool {
            if isEstablishmentClosed {
                OpenOrClosedIndicator.tintColor = UIColor.black
            } else {
                OpenOrClosedIndicator.tintColor = UIColor.yellow
            }
        }
        
        if let restaurantAddessObject = restaurantProperty["location"] as? NSDictionary {
            restaurantAddress.text = restaurantAddessObject["display_address"].map{"\($0)"}?.filter { !"\")(\n\t\r".contains($0) }
        }
        
        if let _ = restaurantPhone.text,
            let restoPhone = restaurantProperty["phone"] as? String, restoPhone.count > 0 {
            restaurantPhone.text = restoPhone
        } else {
            restaurantPhone.text = "No Phone Number available"
        }
        
        if let _ = restaurantRatings.text,
            let restoRatings = restaurantProperty["rating"] as? NSNumber {
            restaurantRatings.text = "\(restoRatings.stringValue) Ratings"
        } else {
            restaurantRatings.text = "No Ratings available"
        }
        
        if let _ = restaurantDeals.text,
            let restoDeals = restaurantProperty["deals"] as? String, restoDeals.count > 0 {
            restaurantDeals.text = restoDeals
        } else {
            restaurantDeals.text = "No Deals available"
        }
        
        if let _ = restaurantImage.image,
            let restoURL = restaurantProperty["image_url"] as? String, restoURL.count > 0 {
            restaurantImage.imageFromUrl(urlString: restoURL)
        }
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                if let imageData = data {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}
