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
    //MARK:- MQTT
    internal var mqTTConfig: MQTTConfig
    internal var mqTTClient: MQTTClient

    //MARK:- Variables: Information Gleaned from Network Discovery
    var ipAddress: String = ""
    var machineName: String = ""
    var hostPort: Int32 = 1883
    var encryption: String = "ssl://"
    
    //MARK:- Variables: Machine Status Information
    var connectionState: ConnectionState = .disconnected {
        didSet {
            connectionStateDelegate?.connectionStateDidChange(connectionState: connectionState)
        }
    }
    var latestMachineStatus: [AristMachineStatus] = []
    
    //MARK:- Variables: Delegates
    var connectionStateDelegate: AristConnectionStatusDelegate?
    
    //MARK:- Initialiser
    init(ipAddress: String, machineName: String, currentViewController: AristCommunicationViewController){
        self.connectionStateDelegate = currentViewController.self
        self.ipAddress = ipAddress
        self.machineName = machineName
        self.mqTTConfig = MQTTConfig(clientId: "AristApp", host: "\(encryption)\(self.ipAddress)", port: self.hostPort, keepAlive: 60)
        self.mqTTClient = MQTT.newConnection(self.mqTTConfig, connectImmediately: false)
        let mQTTServerCert = MQTTServerCert(cafile: generateCertfile()!, capath: nil)
        
        self.mqTTConfig.mqttServerCert = MQTTServerCert(cafile: generateCertfile()!, capath: nil)
        
    }
}

func generateCertfile() -> String? {
    if let filepath = Bundle.main.path(forResource: "Cert", ofType: "strings") {
        do {
            print(filepath)
            return filepath
        }
    }
    
    return nil
}
