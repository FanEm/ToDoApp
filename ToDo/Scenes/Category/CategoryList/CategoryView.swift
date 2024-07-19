//
//  CategoryView.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import SwiftUI
import SwiftData

struct CategoryView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UINavigationController

    var modelContext: ModelContext
    @Binding var category: Category?

    func makeUIViewController(
        context: Context
    ) -> UINavigationController {
        UINavigationController(
            rootViewController: CategoryViewController(
                category: $category,
                modelContext: modelContext
            )
        )
    }

    func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: Context
    ) { }

}

#Preview {
    do {
        @State var category: Category? = Category()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        let context = container.mainContext
        context.insert(Category(text: "Green category", color: "#00ff00"))
        return CategoryView(modelContext: context, category: $category)
            .ignoresSafeArea()
    } catch {
        fatalError()
    }
}
