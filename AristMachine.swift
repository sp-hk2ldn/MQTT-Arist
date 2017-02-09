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

class AristMachine: NSObject, MQTTConnectable {

    //MARK:- Variables: Information Gleaned from Network Discovery
    var session: MQTTSession
    var ipAddress: String = ""
    var machineName: String = ""
    var hostPort: UInt32 = 8443
    var encryption: EncryptionType = .ssl
    
    
    //MARK:- Status
    var connectionStatus: ConnectionState = .disconnected {
        didSet {
            connectionStatusString.value = connectionStatus.rawValue
            connectionStatusLog.append(connectionStatus)
        }
    }
    var connectionStatusString = Observable<String>("")
    var connectionStatusLog = MutableObservableArray<ConnectionState>([])
    var latestMachineStatus = Observable<[AristMachineStatus]>([])
    
    
    //MARK:- Initialiser
    init(ipAddress: String, machineName: String, hostPort: UInt32){
        guard let newSession = MQTTSession() else {
            fatalError("Could not create MQTTSession")
        }
        session = newSession
        super.init()
        newSession.delegate = self
        newSession.securityPolicy = MQTTSSLSecurityPolicy(pinningMode: .none)
        newSession.securityPolicy.validatesCertificateChain = false
        newSession.securityPolicy.allowInvalidCertificates = true
        session = newSession
        self.ipAddress = ipAddress
        self.hostPort = hostPort
        self.machineName = machineName
    }
    
    public func startBrew(recipeSettingsArray: [Int]){
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: recipeSettingsArray)
        session.publishAndWait(data, onTopic: "startBrew", retain: false, qos: .exactlyOnce)
    }
    
    public func stopBrew(){
        session.publishJson("", onTopic: "stopBrew")
    }
    
    //MARK:- These functions are currently here because they cannot be implemented in the MQTTConnectable protocol extension // see #http://stackoverflow.com/questions/39487168/non-objc-method-does-not-satisfy-optional-requirement-of-objc-protocol, should be moved later if possible
    
    internal func connected(_ session: MQTTSession!) {
        connectionStatus = determineConnectionStatus(session: session)
    }
    
    internal func connectionError(_ session: MQTTSession!, error: Error!) {
        connectionStatus = determineConnectionStatus(session: session)
    }
    
    internal func connectionClosed(_ session: MQTTSession!) {
        connectionStatus = determineConnectionStatus(session: session)
    }
    
    
}

