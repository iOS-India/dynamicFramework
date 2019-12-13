//
//  BluetoothAdapter.swift
//  BluetoothCenter
//
//  Created by Anurag Sharma on 04/12/19.
//  Copyright © 2019 Yingbo Wang. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

let iPadsUUID = UUID.init(uuidString: "216FA5C2-67CE-081D-B90B-D30CCD6C9A3A")!
let iPhonesUUID = UUID.init(uuidString: "0DC8E108-9FDB-AA51-2DBB-965B61450888")!


 
// MARK: IOS 13 Releated

@available(iOS 13.0, *)
public class BluetoothAdapter:NSObject,ObservableObject,BLEConnector{
    var myCentralManager: CBCentralManager?
    @Published var discoveredPeripherals = [CBPeripheral]()
    @Published var connectedPeripheral: CBPeripheral?
    var messageCharacteristic: CBCharacteristic?
     @Published public var isConnectedStatus = false
     @Published public var messageReceived = ""
     @Published public var messageToSend = ""
    
    var config : BLEConfig
    public init(config:BLEConfig) {
        self.config = config
    }
    
    
    public func isConnected() -> Bool {
        return isConnectedStatus;
    }
    
    public func connect() {
        if self.myCentralManager == nil {
            self.myCentralManager = CBCentralManager.init(delegate: self, queue: nil, options: nil)
        }
        connectToPeripheral()
    }
    
    public func disconnect() {
        myCentralManager!.stopScan()
    }
    
    public func sendMessage() {
        
        let messageToSend = self.messageToSend.data(using: String.Encoding.utf8)
        //        let messageToSend = message.data(using: String.Encoding.utf8)
        
        guard let checkedConnectedPeripheral = connectedPeripheral else {
            print("Conneccted Peripheral is NIL")
            return
        }
        guard let checkedMessageValue = messageToSend else {
            print("UpdatedValue is NIL")
            return
        }
        guard let checkedMessageCharacterstics = messageCharacteristic else {
            print("Message Characterstic is NIL")
            return
        }
        
        checkedConnectedPeripheral.writeValue(checkedMessageValue, for: checkedMessageCharacterstics, type: CBCharacteristicWriteType.withResponse)
    }
}


@available(iOS 13.0, *)
extension BluetoothAdapter:CBCentralManagerDelegate{
    
    func connectToPeripheral() {
        guard let checkedCenteralManager = myCentralManager else {
            print("Connect to peripheral : centralManager is NIL")
            return  }
        for discovered in discoveredPeripherals {
            
            // now we use service UUID to find the desired device to connect, not device UUID
            print("Connecting to peripheral: \(discovered.identifier)")
            
            connectedPeripheral = discovered
            guard let checkedConnectedPeripheral = connectedPeripheral else {
                print("connected Peripheral is NIL")
                return
                
            }
            
            checkedCenteralManager.connect(checkedConnectedPeripheral, options: nil)
            return
        }
    }
    
    // MARK: CBCentralManagerDelegate
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print(central.state)
            return
        }
        //myCentralManager!.scanForPeripherals(withServices: nil, options: nil)
        myCentralManager!.scanForPeripherals(withServices:config.serviceUUID, options: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var duplicatePeripheral = false
        for discovered in discoveredPeripherals {
            //let discoveredCast = discovered as! CBPeripheral  // awkward type casting!
            if (discovered.identifier == peripheral.identifier) {
                duplicatePeripheral = true
            }
        }
        if (!duplicatePeripheral) {
            print("didDiscover: \(peripheral), \(RSSI)" )
            self.discoveredPeripherals.append(peripheral)
            
        }
        connectToPeripheral()
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect: \(peripheral)")
        isConnectedStatus = true
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        print("didDissConnect: \(peripheral)")
        isConnectedStatus = false
    }
    
}

@available(iOS 13.0, *)
extension BluetoothAdapter: CBPeripheralDelegate{
    
    // MARK: CBPeripheralDelegate
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            print("didDiscoverService: \(service)")
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            print("didDiscoverCharacteristicsFor \(service): \(characteristic)")
            
            if (characteristic.uuid == ASCharacterSticsUUID.myCharacteristicUUID.id()) {
                peripheral.setNotifyValue(true, for: characteristic)
                messageCharacteristic = characteristic
                
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    // the following is called when "readValue" or a notified characteristic is updated
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let data = characteristic.value {
            //let dataString = String(data: data, encoding: String.Encoding.utf8) as! String
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            print("Characteristic data for \(characteristic): \(dataString)")
            if characteristic.uuid == config.charactersticsUUID[0] {
                // update text field
                //  messageLabel!.text = dataString
                print("Messag Received: \(dataString)")
                messageReceived = dataString;
                
            }else{
                messageReceived = "";
            }
        }
        
        print("Characteristic data for \(characteristic): data is nil.")
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil) {
            print(error!)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil) {
            print(error!)
        }
    }
    
}


// MARK: IOS 13 Releated

@available(iOS 9.0, *)
public class BluetoothAdapterDeprecated:NSObject,BLEConnector{
   
    var myCentralManager: CBCentralManager?
    var discoveredPeripherals = [CBPeripheral]()
    var connectedPeripheral: CBPeripheral?
    var messageCharacteristic: CBCharacteristic?
    var isConnectedStatus = false;
    var messageReceived = ""
    var messageToSend = ""
    
    var config : BLEConfig
    init(config:BLEConfig) {
        self.config = config
    }
    
    
    func isConnected() -> Bool {
        return isConnectedStatus;
    }
    
    func connect() {
        if self.myCentralManager == nil {
            self.myCentralManager = CBCentralManager.init(delegate: self, queue: nil, options: nil)
        }
        connectToPeripheral()
    }
    
    func disconnect() {
        myCentralManager!.stopScan()
    }
    
    func sendMessage() {
        
        let messageToSend = self.messageToSend.data(using: String.Encoding.utf8)
        //        let messageToSend = message.data(using: String.Encoding.utf8)
        
        guard let checkedConnectedPeripheral = connectedPeripheral else {
            print("Conneccted Peripheral is NIL")
            return
        }
        guard let checkedMessageValue = messageToSend else {
            print("UpdatedValue is NIL")
            return
        }
        guard let checkedMessageCharacterstics = messageCharacteristic else {
            print("Message Characterstic is NIL")
            return
        }
        
        checkedConnectedPeripheral.writeValue(checkedMessageValue, for: checkedMessageCharacterstics, type: CBCharacteristicWriteType.withResponse)
    }
}


@available(iOS 9.0, *)
extension BluetoothAdapterDeprecated:CBCentralManagerDelegate{
    
    func connectToPeripheral() {
        guard let checkedCenteralManager = myCentralManager else {
            print("Connect to peripheral : centralManager is NIL")
            return  }
        for discovered in discoveredPeripherals {
            
            // now we use service UUID to find the desired device to connect, not device UUID
            print("Connecting to peripheral: \(discovered.identifier)")
            
            connectedPeripheral = discovered
            guard let checkedConnectedPeripheral = connectedPeripheral else {
                print("connected Peripheral is NIL")
                return
                
            }
            
            checkedCenteralManager.connect(checkedConnectedPeripheral, options: nil)
            return
        }
    }
    
    // MARK: CBCentralManagerDelegate
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print(central.state)
            return
        }
        //myCentralManager!.scanForPeripherals(withServices: nil, options: nil)
        myCentralManager!.scanForPeripherals(withServices:config.serviceUUID, options: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var duplicatePeripheral = false
        for discovered in discoveredPeripherals {
            //let discoveredCast = discovered as! CBPeripheral  // awkward type casting!
            if (discovered.identifier == peripheral.identifier) {
                duplicatePeripheral = true
            }
        }
        if (!duplicatePeripheral) {
            print("didDiscover: \(peripheral), \(RSSI)" )
            self.discoveredPeripherals.append(peripheral)
            
        }
        connectToPeripheral()
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect: \(peripheral)")
        isConnectedStatus = true
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        print("didDissConnect: \(peripheral)")
        isConnectedStatus = false
    }
    
}



@available(iOS 9.0, *)
extension BluetoothAdapterDeprecated: CBPeripheralDelegate{
    
    // MARK: CBPeripheralDelegate
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            print("didDiscoverService: \(service)")
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            print("didDiscoverCharacteristicsFor \(service): \(characteristic)")
            
            if (characteristic.uuid == ASServiceUUID.myServiceUUID.id()) {
                peripheral.setNotifyValue(true, for: characteristic)
                messageCharacteristic = characteristic
                
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    // the following is called when "readValue" or a notified characteristic is updated
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let data = characteristic.value {
            //let dataString = String(data: data, encoding: String.Encoding.utf8) as! String
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            print("Characteristic data for \(characteristic): \(dataString)")
            if characteristic.uuid == config.charactersticsUUID[0] {
                // update text field
                //  messageLabel!.text = dataString
                print("Messag Received: \(dataString)")
                messageReceived = dataString;
                
            }else{
                messageReceived = "";
            }
        }
        
        print("Characteristic data for \(characteristic): data is nil.")
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil) {
            print(error!)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil) {
            print(error!)
        }
    }
    
}


