//
//  TodoItemCache.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import FileCache

// MARK: - TodoItemCache
@available(*, deprecated)
final class TodoItemCache: FileCache<TodoItem> {

    nonisolated(unsafe) static let shared = TodoItemCache()

    private override init(defaultFileName: String = "items.json") {
        super.init(defaultFileName: defaultFileName)
    }

}
