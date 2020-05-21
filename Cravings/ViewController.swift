//
//  ViewController.swift
//  Cravings
//
//  Created by ESBoller on 5/21/20.
//  Copyright © 2020 Enrico S Boller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let _ = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.performSegue(withIdentifier: "searchSegue", sender: nil)
            }
        }
    }
}

