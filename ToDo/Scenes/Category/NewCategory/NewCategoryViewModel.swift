//
//  NewCategoryViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import SwiftUI
import SwiftData

// MARK: - NewCategoryViewModel
@MainActor
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
    private let categoryDataHandler: DataHandler<Category>

    init(category: Category = Category(), dataProvider: DataProvider = DataProvider.shared) {
        self.category = category
        self.text = category.text
        self.color = category.color == nil ? nil : Color(hex: category.color!)
        self.categoryDataHandler = dataProvider.categoryDataHandler
    }

    func saveItem() {
        category.text = text
        category.color = color?.hex
        categoryDataHandler.insert(category)
    }

}
