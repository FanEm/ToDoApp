//
//  CalendarView.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import SwiftUI
import SwiftData

struct CalendarView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UINavigationController

    var modelContext: ModelContext

    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: CalendarViewController(modelContext: modelContext))
    }

    func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: Context
    ) {}

}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TodoItem.self, configurations: config)
        let context = container.mainContext
        context.insert(TodoItem(text: "Test"))
        return CalendarView(modelContext: context)
            .ignoresSafeArea()
    } catch {
        fatalError()
    }
}
