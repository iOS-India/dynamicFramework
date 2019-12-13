//
//  ProtocolStack.swift
//  BluetoothCenter
//
//  Created by Anurag Sharma on 04/12/19.
//  Copyright © 2019 Yingbo Wang. All rights reserved.
//

import Foundation

 protocol BLEConnector{
    func connect()
    func disconnect()
    func sendMessage()
    func isConnected()->Bool
}

extension BLEConnector {
    static func instantiate(bleConfig:BLEConfig)->BLEConnector {
        if #available(iOS 13.0, *) {

            return BluetoothAdapter(config:bleConfig);
        } else {
            return BluetoothAdapterDeprecated(config:bleConfig)
        }
    }
}

