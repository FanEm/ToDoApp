//
//  GlobalConstants.swift
//  ToDo
//
//  Created by Artem Novikov on 16.07.2024.
//

import Foundation

enum GlobalConstants {

    static var defaultCategories: [Category] {
        [
            Category(
                id: "DEFAULT-CATEGORY-WORK-ID",
                text: String(localized: "category.work"),
                color: "#ff3b30",
                createdAt: Date(timeIntervalSince1970: 1)
            ),
            Category(
                id: "DEFAULT-CATEGORY-STUDY-ID",
                text: String(localized: "category.study"),
                color: "#007aff",
                createdAt: Date(timeIntervalSince1970: 2)
            ),
            Category(
                id: "DEFAULT-CATEGORY-HOBBY-ID",
                text: String(localized: "category.hobby"),
                color: "#34c759",
                createdAt: Date(timeIntervalSince1970: 3)
            ),
            Category(
                id: "DEFAULT-CATEGORY-OTHER-ID",
                text: String(localized: "category.other"),
                color: nil,
                createdAt: Date(timeIntervalSince1970: 4)
            )
        ]
    }

}
