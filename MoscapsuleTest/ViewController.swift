//
//  ViewController.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 20/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import UIKit
import Moscapsule

class ViewController: AristCommunicationViewController, UITextFieldDelegate {
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
        if textField == connectionAddressTextField {
            networkAddress = textField.text!
            saveActiveNetworkAddress(networkAddress: textField.text!)
            activeMachine = AristMachine(ipAddress: textField.text!, machineName: "Arist", currentViewController: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == connectionAddressTextField {
            textField.resignFirstResponder()
        }
        return true
    }

}

