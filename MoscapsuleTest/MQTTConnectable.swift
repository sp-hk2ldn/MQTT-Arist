//
//  MQTTConnectable.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 23/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import Foundation
import Moscapsule

enum ConnectionState: Int {
    case disconnected = 0, connected
}

protocol MQTTConnectable {
    var mqTTConfig: MQTTConfig { get set }
    var mqTTClient: MQTTClient { get set }
    func connect()
    func disconnect()
}

extension MQTTConnectable where Self:AristMachine {
    func connect() {
        self.mqTTClient.connectTo(mqTTConfig.host, port: mqTTConfig.port, keepAlive: 60) { (result) in
            print(result)
            if result == .mosq_success {
                self.connectionState = .connected
            }
        }
    }
    func disconnect(){
        self.mqTTClient.disconnect({ result in
            print(result)
            self.connectionState = .disconnected
        })
    }
}
