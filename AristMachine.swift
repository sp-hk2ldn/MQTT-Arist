//
//  AristMachine.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 23/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import Foundation
import Moscapsule

class AristMachine: MQTTConnectable {
    
    internal var mqTTConfig: MQTTConfig
    internal var mqTTClient: MQTTClient

    //MARK:- Information Gleaned from Network Discovery
    var ipAddress: String = ""
    var machineName: String = ""
    var hostPort: Int32 = 1883
    var connectionState: ConnectionState = .disconnected {
        didSet {
            connectionStateDelegate?.connectionStateDidChange(connectionState: connectionState)
        }
    }
    var connectionStateDelegate: AristConnectionStatusDelegate?

    init(ipAddress: String, machineName: String, currentViewController: AristCommunicationViewController){
        self.connectionStateDelegate = currentViewController.self
        self.ipAddress = ipAddress
        self.machineName = machineName
        self.mqTTConfig = MQTTConfig(clientId: "AristApp", host: "\(self.ipAddress)", port: self.hostPort, keepAlive: 60)
        self.mqTTClient = MQTT.newConnection(self.mqTTConfig, connectImmediately: false)
    }
}
