//
//  ContentView.swift
//  tedee example
//
//  Created by Mateusz Samosij on 21/02/2024.
//

import SwiftUI
import TedeeLock

struct ContentView: View {
    @Bindable var viewModel: ContentViewModel
    @State var isConnected = false
    @State var command = ""
    @State var parameters = ""
    @FocusState var commandFocus: Bool
    @FocusState var parametersFocus: Bool
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Text(viewModel.serialNumber.serialNumber)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .scaledToFill()
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text(viewModel.isConnected ? "Connected" : "Disconnected")
                        .foregroundStyle(viewModel.isConnected ? .green : .red)
                        .font(.title)
                    Spacer()
                }
            }
            
            
            Section {
                Toggle("Keep connection?", isOn: $viewModel.keepConnection)
                HStack {
                    Button {
                        Task {
                            await viewModel.connect()
                        }
                    } label: {
                        Text("Connect")
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                    Button {
                        Task {
                            await viewModel.disconnect()
                        }
                    } label : {
                        Text("Disconnect")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Command")
                            TextField("0x00", text: $command)
                                .textFieldStyle(.roundedBorder)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .focused($commandFocus)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Parameters")
                            TextField("0x00, 0x00, 0x00", text: $parameters)
                                .textFieldStyle(.roundedBorder)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .focused($parametersFocus)
                        }
                    }
                    Button {
                        commandFocus = false
                        parametersFocus = false
                        Task {
                            await viewModel.sendCommand(command, parameters: parameters)
                        }
                    } label: {
                        Text("Send command")
                    }.buttonStyle(.bordered)
                }
            }
            
            Section {
                ForEach(viewModel.comunicationList.reversed()) { item in
                    Text(item.text)
                }
            }
        }
        .onAppear {
            print("Public key: \(TedeeLockManager.publicKey)")
            viewModel.configureStreams()
        }
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
