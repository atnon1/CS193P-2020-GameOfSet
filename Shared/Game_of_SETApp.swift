//
//  Game_of_SETApp.swift
//  Shared
//
//  Created by Anton Makeev on 16.12.2020.
//

import SwiftUI

@main
struct Game_of_SETApp: App {
    var body: some Scene {
        WindowGroup {
            GameOfSetView(gameProvider: SetGameProvider())
        }
    }
}
