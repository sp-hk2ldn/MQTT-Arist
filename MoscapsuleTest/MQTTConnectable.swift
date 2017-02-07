//
//  MQTTConnectable.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 23/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import Foundation
import MQTTClient

enum ConnectionState: Int {
    case disconnected = 0, connected
}

protocol MQTTConnectable: MQTTSessionDelegate {
    var session: MQTTSession { get set }
    func connect()
    func connected(_ session: MQTTSession!)
}

extension MQTTConnectable where Self:AristMachine {
    
    
    func connect(){
        guard let newSession = MQTTSession() else {
            fatalError("Could not create MQTTSession")
        }
        newSession.delegate = self
        newSession.securityPolicy = MQTTSSLSecurityPolicy(pinningMode: .none)
        newSession.securityPolicy.validatesCertificateChain = false
        newSession.securityPolicy.allowInvalidCertificates = true
        
        self.session = newSession
    }
    
    func connected(_ session: MQTTSession!) {
        
    }
}
