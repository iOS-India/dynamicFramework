//
//  ViewController.swift
//  MainApplication
//
//  Created by Anurag Sharma on 10/12/19.
//  Copyright © 2019 AnuragSharma. All rights reserved.
//

import UIKit
import ASFramework

class ViewController: UIViewController {
let personObj = Person(name: "Anurag Sharma")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        personObj.toString()
    }


}

