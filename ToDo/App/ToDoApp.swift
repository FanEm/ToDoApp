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

    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            TodoList(modelContext: container.mainContext)
                .modelContainer(container)
        }
    }

    init() {
        do {
            container = try ModelContainer(for: TodoItem.self, Category.self)
        } catch {
            fatalError("Failed to create ModelContainer for TodoItemModel")
        }
        Logger.setup()
    }

}
