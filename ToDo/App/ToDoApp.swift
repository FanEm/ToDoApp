//
//  ToDoApp.swift
//  ToDo
//
//  Created by Artem Novikov on 15.06.2024.
//

import SwiftUI
import SwiftData

@main
struct ToDoApp: App {

    let dataProvider = DataProvider.shared

    var body: some Scene {
        WindowGroup {
            TodoList()
                .modelContainer(dataProvider.sharedModelContainer)
        }
    }

    init() {
        Logger.setup()
    }

}
