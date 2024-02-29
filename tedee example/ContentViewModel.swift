//
//  ContentViewModel.swift
//  tedee example
//
//  Created by Mateusz Samosij on 22/02/2024.
//

import Foundation
import TedeeLock

struct ComunicationListItem: Identifiable {
    let id = UUID()
    let text: String
    let date = Date()
    
    init(_ text: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        self.text = dateFormatter.string(from: Date()) + " - " + text
    }
}

@Observable
final class ContentViewModel {
    let serialNumber: TedeeSerialNumber
    let certificate: TedeeCertificate
    
    var isConnected = false
    var keepConnection = false
    var comunicationList = [ComunicationListItem]()
    
    init() {
        do {
            serialNumber = try TedeeSerialNumber(serialNumber: Configuration.SerialNumber)
            certificate = try TedeeCertificate(certificate: Configuration.Certificate,
                                               expirationDate: Configuration.expirationDate,
                                               devicePublicKey: Configuration.DevicePublicKey,
                                               mobilePublicKey: Configuration.MobilePublicKey)
        } catch {
            fatalError("\(error)")
        }
    }
    
    @MainActor
    func connect() async {
        do {
            try await TedeeLockManager.shared.connect(serialNumber, certificate: certificate, keepConnection: keepConnection)
            isConnected = true
        } catch {
            comunicationList.append(ComunicationListItem("connection error: \(error)"))
        }
    }
    
    @MainActor
    func disconnect() async {
        do {
            try await TedeeLockManager.shared.disconnect(serialNumber)
            isConnected = false
        } catch {
            comunicationList.append(ComunicationListItem("disconnection error: \(error)"))
        }
    }
    
    @MainActor
    func sendCommand(_ command: String, parameters: String) async {
        Task {
            guard let commandHex = UInt8(command.dropFirst(2), radix: 16) else { return }
            
            let parameters = parameters.split(separator: ", ").compactMap({ UInt8($0.dropFirst(2), radix: 16) })
            
            do {
                comunicationList.append(ComunicationListItem("request: \(command) params: \(parameters)"))
                
                let response = try await TedeeLockManager.shared.sendCommand(serialNumber, command: commandHex, parameters: parameters)
                
                comunicationList.append(ComunicationListItem("response: \(response)"))
            } catch {
                comunicationList.append(ComunicationListItem("send error: \(error)"))
            }
        }
    }
    
    func configureStreams() {
        Task { @MainActor in
            for await serialNumber in TedeeLockManager.shared.onDisconnectionStream {
                if self.serialNumber.serialNumber == serialNumber.serialNumber {
                    isConnected = false
                    comunicationList.removeAll()
                }
            }
        }
        
        Task { @MainActor in
            for await serialNumber in TedeeLockManager.shared.onConnectionStream {
                if self.serialNumber.serialNumber == serialNumber.serialNumber {
                    isConnected = true
                }
            }
        }
        
        Task { @MainActor in
            for await notification in TedeeLockManager.shared.notificationsStream {
                if self.serialNumber.serialNumber == notification.0.serialNumber {
                    comunicationList.append(ComunicationListItem("notification: \(notification.1)"))
                }
            }
        }
    }
}
