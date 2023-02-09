/*+===================================================================
 File: NetworkManager.swift
 
 Summary: A model that watches and gives information about internet connection
 
 Exported Data Structures: NetworkManager - the model
    isConnected - boolean to indicates if there is a network connection or not
 
 Exported Functions: init - constructor
 
 Contributors:
    Jacob Losco - 1/29/2022 - SP-349
===================================================================+*/

import Foundation
import Network

class NetworkManager: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
}
