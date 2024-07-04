//
//  NewCategoryViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import SwiftUI

// MARK: - NewCategoryViewModel
final class NewCategoryViewModel: ObservableObject {

    @Published var canItemBeSaved: Bool = false
    @Published var text: String {
        didSet {
            canItemBeSaved = text != ""
        }
    }
    var color: Color?
    var selectedColor: Color = .white {
        didSet {
            color = selectedColor
        }
    }

    private let category: Category
    private let categoryCache: CategoryCache

    init(
        category: Category = Category(),
        categoryCache: CategoryCache = CategoryCache.shared
    ) {
        self.category = category
        self.categoryCache = categoryCache
        self.text = category.text
        self.color = category.color == nil ? nil : Color(hex: category.color!)
    }

    func saveItem() {
        categoryCache.addItemAndSaveJson(Category(id: category.id, text: text, color: color?.hex))
    }

}
