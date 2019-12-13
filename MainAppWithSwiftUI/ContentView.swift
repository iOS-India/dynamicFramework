//
//  ContentView.swift
//  MainAppWithSwiftUI
//
//  Created by Anurag Sharma on 12/12/19.
//  Copyright © 2019 AnuragSharma. All rights reserved.
//

import SwiftUI
import ASFramework

struct ContentView: View {
    
        let person1 = Person(name: "Anurag")
        let person2 = Person(name: "Shamik")
        let course = Course()
    var body: some View {
        VStack{
        BLEView()
        }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
