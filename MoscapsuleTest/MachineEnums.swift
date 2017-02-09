//
//  MachineStatusEnums
//  MoscapsuleTest
//
//  Created by Stephen Parker on 08/02/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import Foundation

enum MachineModuleStatus {
    case Error
    case Okay
}

enum MachineStatusErrorCode: Int {
    case someError = 0, anotherError, yetAnotherError
}

enum ConnectionState: String {
    case disconnected = "disconnected", connected = "connected", error = "error", pending = "pending"
}

enum EncryptionType: String {
    case ssl = "ssl://", none = ""
}
