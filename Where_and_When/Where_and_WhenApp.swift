//
//  TimeGuessrApp.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 10/07/2023.
//

import SwiftUI

@main
struct Where_and_WhenApp: App {
    @ObservedObject var router = Router()
    
    init() {
            let defaults: [String: Any] = [
                "HighScore": 0
            ]
            
            UserDefaults.standard.register(defaults: defaults)
        }

    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(router)
        }
    }
}
