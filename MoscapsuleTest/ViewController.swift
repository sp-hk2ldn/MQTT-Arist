//
//  ViewController.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 20/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import UIKit
//import SwiftMQTT
import MQTTClient
import Bond

class ViewController: AristCommunicationViewController, UITextFieldDelegate, MQTTSessionDelegate {
    
    //** Machine Configuration **//
    var networkAddress: String = "" {
        didSet {
            connectionAddressTextField.placeholder = networkAddress
        }
    }
    
    var loadingIndicator: UIActivityIndicatorView?
    
    var activeMachine: AristMachine?
    var tableViewSetup: Bool = false
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var reactivetestlabel: UILabel!
    @IBOutlet var connectionButton: UIButton!
    @IBOutlet var disconnectionButton: UIButton!
    @IBOutlet var connectionAddressTextField: UITextField! {
        didSet {
            connectionAddressTextField.delegate = self
        }
    }
    
    @IBAction func connectToArist(_ sender: UIButton) {
        activeMachine?.connect()
        if !tableViewSetup {
            setupTableview()
            tableViewSetup = true
        }
    }
    
    @IBAction func disconnectFromArist(_ sender: UIButton) {
        activeMachine?.disconnect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveActiveNetworkAddress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    fileprivate func setupTableview(){
        activeMachine?.connectionStatusLog.bind(to: tableView) { [weak self] dataSources, indexPath, tableView in
            guard let weakSelf = self else { return UITableViewCell() }
            let cell = weakSelf.tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! MachineStatusTableViewCell
            let dataSource = dataSources[indexPath.row]
            cell.statusLabel.text = dataSource.rawValue
            return cell
        }
    }
    
    //MARK:- Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == connectionAddressTextField {
            networkAddress = textField.text!
            saveActiveNetworkAddress(networkAddress: textField.text!)
            activeMachine = AristMachine(ipAddress: textField.text!, machineName: "arist", hostPort: 8443)
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == connectionAddressTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

class MachineStatusTableViewCell: UITableViewCell {
    @IBOutlet var statusLabel: UILabel!
}


