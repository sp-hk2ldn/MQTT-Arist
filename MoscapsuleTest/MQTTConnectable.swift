//
//  MQTTConnectable.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 23/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import Foundation
import MQTTClient



protocol MQTTConnectable: MQTTSessionDelegate {
    var session: MQTTSession { get set }
    func connect()
    func disconnect()
}

extension MQTTConnectable where Self:AristMachine {
        
    func connect(){
        session.connect(toHost: self.ipAddress, port: self.hostPort, usingSSL: true)
    }
    
    func getConnectionStatus() -> ConnectionState? {
        return self.connectionStatusLog.array.last
    }
    
    func disconnect(){
        session.disconnect()
    }
    
    internal func determineConnectionStatus(session: MQTTSession) -> ConnectionState {
        switch session.status {
        case .error:
            return .error
        case .connected, .created:
            return .connected
        case .connecting, .disconnecting:
            return .pending
        case .closed:
            return .disconnected
        }
    }
    
    
}
