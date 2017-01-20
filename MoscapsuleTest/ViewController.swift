//
//  ViewController.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 20/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import UIKit
import Moscapsule

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func testTopicButton(_ sender: UIButton) {
//        mqttClient?.subscribe("/Sample/Repeating", qos: 2)
        mqttClient?.publish(string: "asdokasdopksadpoasdk", topic: "/Sample/Request", qos: 2, retain: false)
    }
    var mqttConfig: MQTTConfig?
    var mqttClient: MQTTClient?
    var connectOrDisconnectClosure: (() -> Void)? = nil
    //** Machine Configuration **//
    var networkAddress: String = ""
    var networkPort: Int32 = 1883
    var keepAliveTime: Int32 = 60
    
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
    var machineResponseCode: Moscapsule.ReturnCode = .unknown {
        didSet {
            switch machineResponseCode {
            case .success:
                break
            default:
                break
            }
        }
    }

    @IBOutlet var connectionButton: UIButton!
    @IBOutlet var connectionAddressTextField: UITextField! {
        didSet {
            connectionAddressTextField.delegate = self
        }
    }
    @IBOutlet var machineResponseTextView: UITextView!
    
    @IBAction func connectToArist(_ sender: UIButton) {
        connectOrDisconnectClosure!()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if connectOrDisconnectClosure == nil {
            connectOrDisconnectClosure = initMoscapsule
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initMoscapsule(){
        if mqttConfig == nil {
            mqttConfig = MQTTConfig(clientId: "iPhone Barebones Client v1.0", host: "\(networkAddress)", port: networkPort, keepAlive: keepAliveTime)
            mqttConfig?.onConnectCallback = {
                returnCode in
                self.machineResponse = returnCode.description
                self.machineResponseCode = returnCode
                self.connectOrDisconnectClosure = self.disconnectFromMqtt
                self.setConnectionButtonUI(connected: true)
            }
            mqttConfig?.onMessageCallback = { responseMessage in
                if let responseString = responseMessage.payloadString {
                    self.machineResponse = responseString
                }
            }
            mqttConfig?.onSubscribeCallback = { responseMessage in
                print(responseMessage.0)
                print(responseMessage.1)
            }
        }
        if mqttClient == nil {
            mqttClient = MQTT.newConnection(mqttConfig!)
        } else {
            mqttClient!.reconnect()
            self.connectionButton.setTitle("Disconnect", for: .normal)
            self.connectionButton.backgroundColor = UIColor.red
        }
    }
    
    fileprivate func disconnectFromMqtt(){
        if mqttClient != nil {
            mqttClient?.disconnect()
            self.connectOrDisconnectClosure = initMoscapsule
            self.machineResponse = "Disconnected..."
            self.setConnectionButtonUI(connected: false)
        }
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
        if textField == connectionAddressTextField {
            networkAddress = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == connectionAddressTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    


}

