//
//  ContentView.swift
//  MainAppWithSwiftUI
//
//  Created by Anurag Sharma on 10/12/19.
//  Copyright © 2019 AnuragSharma. All rights reserved.
//

import SwiftUI
import ASFramework

@available(iOS 13.0, *)
struct ConnectedStatus: View {
    
    @Binding var isConnected: Bool
    
    var body: some View {
        Text( isConnected ? "Connected" : "Not Conncted" )
        
    }
}


@available(iOS 13.0, *)
public struct BLEView: View {
    
    @ObservedObject var ble:BluetoothAdapter = BluetoothAdapter(config: BLEConfig(kindOF: BLEROLE.Central, serviceUUID: [ASServiceUUID.myServiceUUID.id()], charUUIDS: [ASCharacterSticsUUID.myCharacteristicUUID.id()]))
//    @ObservedObject var ble:BluetoothAdapter =  BluetoothAdapterDeprecated.instantiate(bleConfig: BLEConfig(kindOF: BLEROLE.Central, serviceUUID: [ASServiceUUID.myServiceUUID.id()], charUUIDS: [ASCharacterSticsUUID.myCharacteristicUUID.id()])) as! BluetoothAdapter

    public init(){}
    
    public var body: some View {
        
        return
            NavigationView{
                VStack{
                    
                    Form{
                        Section(header: Text("Status")) {
                            HStack{
                                ConnectedStatus(isConnected: $ble.isConnectedStatus)
                                Spacer()
                                Button(action: {self.ble.connect()}) {
                                    Text("Connect")
                                }
                            }
                        }
                        Section(header: Text("Message To Send")) {
                            HStack{
                                TextField("Enter Message To Send", text: $ble.messageToSend)
                                    .autocapitalization(.words)
                                Button(action: {
                                    self.ble.sendMessage()
                                }) {
                                    Text("Send Data")
                                }
                            }
                        }
                        Section(header: Text("Message Received")) {
                            Text(ble.messageReceived)
                                .padding()
                                .multilineTextAlignment(.center)
                        }
                        
                        
                    }
                    .navigationBarTitle("Bluetooth")
                    
                }
        }
    }
}

