//
//  Constants.swift
//  BluetoothCenter
//
//  Created by Anurag Sharma on 04/12/19.
//  Copyright © 2019 Yingbo Wang. All rights reserved.
//

import Foundation
import CoreBluetooth

//let myServiceUUID = CBUUID.init(string: "9B1F32B2-95FA-4E5A-8D10-5F704AC73DAB")
//let myCharacteristicUUID = CBUUID.init(string: "7E1DF8E3-AA0E-4F16-B9AB-43B28D73AF25")

public enum ASServiceUUID{
    case myServiceUUID
   public func id() -> CBUUID {
        switch self {
        case .myServiceUUID:
            return CBUUID.init(string: "9B1F32B2-95FA-4E5A-8D10-5F704AC73DAB")
    
        }
    }
}
public enum ASCharacterSticsUUID{
    case myCharacteristicUUID
    
    public func id() -> CBUUID {
        switch self {
        case .myCharacteristicUUID:
            return CBUUID.init(string: "7E1DF8E3-AA0E-4F16-B9AB-43B28D73AF25")
        }
    }
}

public enum BLEROLE
{
    case Central
    case Peripheral
}

public struct BLEConfig {
    var kindOF: BLEROLE
    var serviceUUID:[CBUUID]
    var charactersticsUUID:[CBUUID]
   
    public init(kindOF:BLEROLE,serviceUUID:[CBUUID],charUUIDS:[CBUUID]){
        self.kindOF = kindOF
        self.serviceUUID = serviceUUID
        self.charactersticsUUID = charUUIDS
    }
}

