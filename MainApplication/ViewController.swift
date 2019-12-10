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
    
var persons:[Person]?
let personObj1 = Person(name: "Anurag Sharma")
let personObj2 = Person(name: "Kapil Sharma")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let course = Course()
        course.registerPerson(personObj1);
        course.registerPerson(personObj2);
        persons = course.persons()
        if let persons = persons {
            for person in persons {
                print(person.asname)
            }
        }
    }

}

