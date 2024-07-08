//
//  ToDoApp.swift
//  ToDo
//
//  Created by Artem Novikov on 15.06.2024.
//

import SwiftUI

@main
struct ToDoApp: App {

    init() {
        Logger.setup()
    }

    var body: some Scene {
        WindowGroup {
            TodoList()
        }
    }

}
