//
//  TodoItemSwiftDataTests.swift
//  ToDoTests
//
//  Created by Artem Novikov on 17.07.2024.
//

import XCTest
import SwiftData
@testable import ToDo

final class TodoItemSwiftDataTests: XCTestCase {

    var container: ModelContainer!

    private enum Constants {
        enum TodoItem {
            static let id = UUID().uuidString
            static let text = "TodoItem name"
            static let editedText = "Edited TodoItem name"
            static let importance: Importance = .basic
            static let editedImportance: Importance = .important
            static let deadline: Date? = nil
            static let editedDeadline: Date? = Date(timeIntervalSince1970: 1721226709)
            static let isDone = false
            static let editedIsDone = true
            static let createdAt = Date(timeIntervalSince1970: 1721326709)
            static let modifiedAt = Date(timeIntervalSince1970: 1721326720)
            static let editedModifiedAt = Date(timeIntervalSince1970: 1721326726)
            static let color: String? = nil
            static let editedColor: String? = "#ff00ff"
        }

        enum Category {
            static let id = UUID().uuidString
            static let text = "Category name"
            static let editedText = "Edited Category name"
            static let color = "#ff0000"
            static let editedColor: String? = nil
            static let createdAt = Date(timeIntervalSince1970: 1721326709)
        }
    }

    override func setUpWithError() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: TodoItem.self, Category.self,
            configurations: configuration
        )
    }

    override func tearDownWithError() throws {
        container = nil
    }

    @MainActor func testCreateTodoItem() throws {
        // given
        let context = container.mainContext
        let category = Category(
            id: Constants.Category.id,
            text: Constants.Category.text,
            color: Constants.Category.color,
            createdAt: Constants.Category.createdAt
        )
        context.insert(category)
        let todoItem = TodoItem(
            id: Constants.TodoItem.id,
            text: Constants.TodoItem.text,
            importance: Constants.TodoItem.importance,
            deadline: Constants.TodoItem.deadline,
            isDone: Constants.TodoItem.isDone,
            createdAt: Constants.TodoItem.createdAt,
            modifiedAt: Constants.TodoItem.modifiedAt,
            color: Constants.TodoItem.color,
            category: category
        )

        // when
        context.insert(todoItem)

        // then
        let fetchRequest = FetchDescriptor<ToDo.TodoItem>()
        let fetchedTodoItems = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedTodoItems.count, 1)
        let savedTodoItem = try XCTUnwrap(fetchedTodoItems.first)
        XCTAssertEqual(savedTodoItem.id, Constants.TodoItem.id)
        XCTAssertEqual(savedTodoItem.text, Constants.TodoItem.text)
        XCTAssertEqual(savedTodoItem.importance, Constants.TodoItem.importance)
        XCTAssertEqual(savedTodoItem.deadline, Constants.TodoItem.deadline)
        XCTAssertEqual(savedTodoItem.isDone, Constants.TodoItem.isDone)
        XCTAssertEqual(savedTodoItem.createdAt, Constants.TodoItem.createdAt)
        XCTAssertEqual(savedTodoItem.modifiedAt, Constants.TodoItem.modifiedAt)
        XCTAssertEqual(savedTodoItem.color, Constants.TodoItem.color)
        XCTAssertEqual(savedTodoItem.category, category)
    }

    @MainActor func testEditTodoItem() throws {
        // given
        let context = container.mainContext
        let category = Category(
            id: Constants.Category.id,
            text: Constants.Category.text,
            color: Constants.Category.color,
            createdAt: Constants.Category.createdAt
        )
        context.insert(category)
        let todoItem = TodoItem(
            id: Constants.TodoItem.id,
            text: Constants.TodoItem.text,
            importance: Constants.TodoItem.importance,
            deadline: Constants.TodoItem.deadline,
            isDone: Constants.TodoItem.isDone,
            createdAt: Constants.TodoItem.createdAt,
            modifiedAt: Constants.TodoItem.modifiedAt,
            color: Constants.TodoItem.color,
            category: nil
        )
        context.insert(todoItem)

        // when
        todoItem.text = Constants.TodoItem.editedText
        todoItem.importance = Constants.TodoItem.editedImportance
        todoItem.deadline = Constants.TodoItem.editedDeadline
        todoItem.isDone = Constants.TodoItem.editedIsDone
        todoItem.modifiedAt = Constants.TodoItem.editedModifiedAt
        todoItem.color = Constants.TodoItem.editedColor
        todoItem.category = category

        // then
        let fetchRequest = FetchDescriptor<ToDo.TodoItem>()
        let fetchedTodoItems = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedTodoItems.count, 1)
        let savedTodoItem = try XCTUnwrap(fetchedTodoItems.first)
        XCTAssertEqual(savedTodoItem.id, Constants.TodoItem.id)
        XCTAssertEqual(savedTodoItem.text, Constants.TodoItem.editedText)
        XCTAssertEqual(savedTodoItem.importance, Constants.TodoItem.editedImportance)
        XCTAssertEqual(savedTodoItem.deadline, Constants.TodoItem.editedDeadline)
        XCTAssertEqual(savedTodoItem.isDone, Constants.TodoItem.editedIsDone)
        XCTAssertEqual(savedTodoItem.createdAt, Constants.TodoItem.createdAt)
        XCTAssertEqual(savedTodoItem.modifiedAt, Constants.TodoItem.editedModifiedAt)
        XCTAssertEqual(savedTodoItem.color, Constants.TodoItem.editedColor)
        XCTAssertEqual(savedTodoItem.category, category)
    }

    @MainActor func testDeleteTodoItem() throws {
        // given
        let context = container.mainContext
        let todoItem = TodoItem(text: "Name")
        context.insert(todoItem)

        // when
        context.delete(todoItem)

        // then
        let fetchRequest = FetchDescriptor<ToDo.TodoItem>()
        let fetchedTodoItems = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedTodoItems.count, 0)
    }

    @MainActor func testCreateCategory() throws {
        // given
        let context = container.mainContext
        let category = Category(
            text: Constants.Category.text,
            color: Constants.Category.color,
            createdAt: Constants.Category.createdAt
        )

        // when
        context.insert(category)

        // then
        let fetchRequest = FetchDescriptor<ToDo.Category>()
        let fetchedCategories = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedCategories.count, 1)
        let savedCategory = try XCTUnwrap(fetchedCategories.first)
        XCTAssertNotNil(savedCategory.id)
        XCTAssertEqual(savedCategory.text, Constants.Category.text)
        XCTAssertEqual(savedCategory.color, Constants.Category.color)
        XCTAssertEqual(savedCategory.createdAt, Constants.Category.createdAt)
    }

    @MainActor func testEditCategory() throws {
        // given
        let context = container.mainContext
        let category = Category(
            id: Constants.Category.id,
            text: Constants.Category.text,
            color: Constants.Category.color,
            createdAt: Constants.Category.createdAt
        )
        context.insert(category)

        // when
        category.text = Constants.Category.editedText
        category.color = Constants.Category.editedColor

        // then
        let fetchRequest = FetchDescriptor<ToDo.Category>()
        let fetchedCategories = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedCategories.count, 1)
        let savedCategory = try XCTUnwrap(fetchedCategories.first)
        XCTAssertEqual(savedCategory.id, Constants.Category.id)
        XCTAssertEqual(savedCategory.text, Constants.Category.editedText)
        XCTAssertEqual(savedCategory.color, Constants.Category.editedColor)
        XCTAssertEqual(savedCategory.createdAt, Constants.Category.createdAt)
    }

    @MainActor func testDeleteCategory() throws {
        // given
        let context = container.mainContext
        let category = Category()
        context.insert(category)

        // when
        context.delete(category)

        // then
        let fetchRequest = FetchDescriptor<ToDo.Category>()
        let fetchedCategories = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedCategories.count, 0)
    }

}
