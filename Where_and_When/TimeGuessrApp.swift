//
//  TimeGuessrApp.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 10/07/2023.
//

import SwiftUI

@main
struct TimeGuessrApp: App {
    @ObservedObject var router = Router()
    
    init() {
            // Define default values for user defaults keys
            let defaults: [String: Any] = [
                "HighScore": 0
                // Add more default values if needed
            ]
            
            // Register default values for user defaults
            UserDefaults.standard.register(defaults: defaults)
        }

    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(router)
        }
    }
}
