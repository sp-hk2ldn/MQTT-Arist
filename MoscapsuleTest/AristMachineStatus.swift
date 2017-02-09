//
//  AristMachineStatus
//  MoscapsuleTest
//
//  Created by Stephen Parker on 25/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import Foundation
import SwiftyJSON



class AristMachineStatus: AristMachineCommunicator {
    
    fileprivate var syrup1: Bool = false
    fileprivate var syrup2: Bool = false
    fileprivate var water_tank: Bool = false
    fileprivate var bean_tank: Bool = false
    fileprivate var waste_tank: Bool = false
    fileprivate var drip_tray: Bool = false
    fileprivate var error_code: Int = 0
    
    required init(jsonObject: JSON){
        self.syrup1 = jsonObject["syrup1"].boolValue
        self.syrup2 = jsonObject["syrup2"].boolValue
        self.water_tank = jsonObject["water_tank"].boolValue
        self.bean_tank = jsonObject["water_tank"].boolValue
        self.waste_tank = jsonObject["waste_tank"].boolValue
        self.drip_tray = jsonObject["drip_tray"].boolValue
        self.error_code = jsonObject["error_code"].intValue
        super.init(jsonObject: jsonObject)
    }
    
    fileprivate func determineIfModuleHasError(statusBool: Bool) -> MachineModuleStatus {
        if statusBool == true {
            return .Error
        }
        return .Okay
    }
    
    public var syrup1Status: MachineModuleStatus {
        get {
            return determineIfModuleHasError(statusBool: syrup1)
        }
    }
    public var syrup2Status: MachineModuleStatus {
        get {
            return determineIfModuleHasError(statusBool: syrup2)
        }
    }
    public var waterTankStatus: MachineModuleStatus {
        get {
            return determineIfModuleHasError(statusBool: water_tank)
        }
    }
    public var beanTankStatus: MachineModuleStatus {
        get {
            return determineIfModuleHasError(statusBool: bean_tank)
        }
    }
    public var wasteTankStatus: MachineModuleStatus {
        get {
            return determineIfModuleHasError(statusBool: waste_tank)
        }
    }
    public var dripTrayStatus: MachineModuleStatus {
        get {
            return determineIfModuleHasError(statusBool: drip_tray)
        }
    }
}
