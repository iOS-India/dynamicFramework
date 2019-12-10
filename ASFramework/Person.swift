//
//  Person.swift
//  ASFramework
//
//  Created by Anurag Sharma on 10/12/19.
//  Copyright © 2019 AnuragSharma. All rights reserved.
//

import Foundation
public class Person{
    let name:String
    public init(name:String) {
        self.name = name
    }
    
   public func toString() -> Void {
        print("Person = Name \(self.name)")
    }
}
