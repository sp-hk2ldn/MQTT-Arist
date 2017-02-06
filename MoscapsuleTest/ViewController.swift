//
//  ViewController.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 20/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import UIKit
import Moscapsule
//import SwiftMQTT
import MQTTClient

class ViewController: AristCommunicationViewController, UITextFieldDelegate, MQTTSessionDelegate {
    
    var sessionConnected = false
    var sessionError = false
    var sessionReceived = false
    var sessionSubAcked = false
    var session: MQTTSession?
    
    //** Machine Configuration **//
    var networkAddress: String = "" {
        didSet {
            connectionAddressTextField.placeholder = networkAddress
        }
    }
    
    //** Machine Response **//
    var machineResponse: String = "" {
        didSet {
            DispatchQueue.main.async {
                let timeStamp = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                let timeStampString = formatter.string(from: timeStamp)
                self.machineResponseTextView.text = "[\(timeStampString)]\(self.machineResponse)\n\(self.machineResponseTextView.text!)"
            }
        }
    }
    
    var loadingIndicator: UIActivityIndicatorView?
    
    var activeMachine: AristMachine?
    
    @IBOutlet var connectionButton: UIButton!
    @IBOutlet var connectionAddressTextField: UITextField! {
        didSet {
            connectionAddressTextField.delegate = self
        }
    }
    @IBOutlet var machineResponseTextView: UITextView!
    
    @IBAction func connectToArist(_ sender: UIButton) {
        activeMachine?.connect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveActiveNetworkAddress()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func saveActiveNetworkAddress(networkAddress: String){
        UserDefaults.standard.set(networkAddress, forKey: "activeNetworkAddress")
    }
    
    fileprivate func retrieveActiveNetworkAddress(){
        guard let savedNetworkAddress = UserDefaults.standard.string(forKey: "activeNetworkAddress") else { return }
        self.networkAddress = savedNetworkAddress
    }
    
    fileprivate func setConnectionButtonUI(connected: Bool){
        DispatchQueue.main.async { 
            if connected {
                self.connectionButton.setTitle("Disconnect", for: .normal)
                self.connectionButton.backgroundColor = UIColor.red
            } else {
                self.connectionButton.setTitle("Connect", for: .normal)
                self.connectionButton.backgroundColor = UIColor(red: 61/255, green: 185/255, blue: 128/255, alpha: 1.0)
            }
        }
    }
    
    
    //MARK:- Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == connectionAddressTextField {
//            networkAddress = textField.text!
//            saveActiveNetworkAddress(networkAddress: textField.text!)
//            activeMachine = AristMachine(ipAddress: textField.text!, machineName: "Arist", currentViewController: self)
//        
//        }
        testSwiftSubscribe()
        
        print("mqttSession Start")
    }
    
    func mqttSession(session: MQTTSession, received message: Data, in topic: String) {
        let string = String(data: message, encoding: .utf8)!
        print("data received on topic \(topic) message \(string)")
    }
    
    func mqttSocketErrorOccurred(session: MQTTSession) {
        print("Socket Error")
    }
    
    func mqttDidDisconnect(session: MQTTSession) {
        print("Session Disconnected.")
    }
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        switch eventCode {
        case .connected:
            sessionConnected = true
        case .connectionClosed:
            sessionConnected = false
        default:
            sessionError = true
        }
    }
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        print("Received \(data) on:\(topic) q\(qos) r\(retained) m\(mid)")
        
        let dataString = String(data: data, encoding: String.Encoding.utf8)
        print("Received \(dataString)")
        sessionReceived = true;
    }
    
    func subAckReceived(_ session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [NSNumber]!) {
        sessionSubAcked = true;
    }
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == connectionAddressTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func testSwiftSubscribe() {
        
        
        guard let newSession = MQTTSession() else {
            fatalError("Could not create MQTTSession")
        }
        session = newSession
        
    
    
        newSession.delegate = self

        newSession.securityPolicy = MQTTSSLSecurityPolicy(pinningMode: .none)
        newSession.securityPolicy.validatesCertificateChain = false
        newSession.securityPolicy.allowInvalidCertificates = true
        
        newSession.connect(toHost: "192.168.1.132", port: 8443, usingSSL: true)
        
        while !sessionConnected && !sessionError {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        newSession.subscribe(toTopic: "/Sample/Repeating", at: .atMostOnce)
        
        while sessionConnected && !sessionError && !sessionSubAcked {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        newSession.publishData("sent from Xcode using Swift".data(using: String.Encoding.utf8, allowLossyConversion: false),
                               onTopic: "/Sample/Request",
                               retain: false,
                               qos: .atMostOnce)
        
        while sessionConnected && !sessionError && !sessionReceived {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
    }
    

}

