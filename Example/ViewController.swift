//
//  ViewController.swift
//  Example
//
//  Created by Eli Perkins on 8/30/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import UIKit
import Tappd

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    @IBAction func signInAction(sender: AnyObject) {
        Client.clientFromWebAuth("xxx", redirectURL: NSURL(string: "tappdexample://auth.com")!) { result in
            print(result)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

