//
//  AristCommunicationViewController.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 25/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import UIKit

protocol AristConnectionStatusDelegate {
    func connectionStateDidChange(connectionState: ConnectionState)
}

class AristCommunicationViewController: UIViewController, AristConnectionStatusDelegate {
    
    
    var aristConnectionState: ConnectionState = .disconnected
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connectionStateDidChange(connectionState: ConnectionState) {
        aristConnectionState = connectionState
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
