//
//  tedee_exampleApp.swift
//  tedee example
//
//  Created by Mateusz Samosij on 21/02/2024.
//

import SwiftUI

@main
struct tedee_exampleApp: App {
    @StateObject private var viewModel = ContentViewModel()

    init() {
        // Initialize notification manager
        Task { @MainActor in
            let notificationManager = NotificationManager.shared

            // Setup notification categories
            notificationManager.setupNotificationCategories()

            // Request authorization
            do {
                try await notificationManager.requestAuthorization()

                // Show persistent notification
                try await notificationManager.showPersistentNotification()
            } catch {
                print("Notification setup error: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .onAppear {
                    // Setup notification action handler
                    NotificationManager.shared.onActionReceived = { actionIdentifier in
                        await self.viewModel.handleNotificationAction(actionIdentifier)
                    }
                }
        }
    }
}
