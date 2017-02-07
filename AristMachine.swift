//
//  AristMachine.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 23/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import Foundation
import MQTTClient
import Bond

class AristMachine: NSObject, MQTTSessionDelegate {

    //MARK:- Variables: Information Gleaned from Network Discovery
    var session: MQTTSession!
    var ipAddress: String = ""
    var machineName: String = ""
    var hostPort: UInt32 = 8443
    
    var encryption: String = "ssl://"
    
    
    //MARK:- Status
    var connectionStatus: ConnectionState = .disconnected {
        didSet {
            connectionStatusString.value = connectionStatus.rawValue
            connectionStatusLog.append([Date(): connectionStatus])
        }
    }
    var connectionStatusString = Observable<String>("")
    var connectionStatusLog: [[Date:ConnectionState]] = []
    var latestMachineStatus = Observable<[AristMachineStatus]>([])
    
    
    //MARK:- Initialiser
    init(ipAddress: String, machineName: String, hostPort: UInt32){
        super.init()
        self.ipAddress = ipAddress
        self.hostPort = hostPort
        self.machineName = machineName
        guard let newSession = MQTTSession() else {
            fatalError("Could not create MQTTSession")
        }
        newSession.delegate = self
        newSession.securityPolicy = MQTTSSLSecurityPolicy(pinningMode: .none)
        newSession.securityPolicy.validatesCertificateChain = false
        newSession.securityPolicy.allowInvalidCertificates = true
        session = newSession
    }
    
    public func connect(){
        session?.connect(toHost: self.ipAddress, port: self.hostPort, usingSSL: true)
    }
    
    public func getConnectionStatus() -> [Date: ConnectionState]? {
        return connectionStatusLog.last
    }
    
    internal func connected(_ session: MQTTSession!) {
        if session.status == .connected {
            connectionStatus = .connected
        }
    }
    
    func disconnect(){
        session?.disconnect()
    }
    
    internal func connectionClosed(_ session: MQTTSession!) {
        if session.status == .closed {
            connectionStatus = .disconnected
        }
    }
    
}

