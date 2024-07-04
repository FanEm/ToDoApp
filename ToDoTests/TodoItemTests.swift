//
//  TodoItemTests.swift
//  ToDoTests
//
//  Created by Artem Novikov on 15.06.2024.
//

import XCTest
@testable import ToDo

// swiftlint:disable line_length
final class TodoItemTests: XCTestCase {

    private enum Constants {
        static let id = UUID().uuidString
        static let text = "Text"
        static let ts: TimeInterval = 1718465615
        static let date = Date(timeIntervalSince1970: ts)
        static let priority: TodoItem.Priority = .high
        static let isDone = false
        static let color: String? = "#ffffff"
        static let categoryId: String? = "ID-1"

        enum TodoItems {
            static let full = TodoItem(
                id: id,
                text: text,
                priority: priority,
                deadline: date,
                isDone: isDone,
                createdAt: date,
                modifiedAt: date,
                color: color,
                categoryId: categoryId
            )
            static let onlyRequired = TodoItem(
                id: id,
                text: text,
                priority: .medium,
                isDone: isDone,
                createdAt: date
            )
        }
    }

    func testInit() {
        let todoItem = TodoItem(
            id: Constants.id,
            text: Constants.text,
            priority: Constants.priority,
            deadline: Constants.date,
            isDone: Constants.isDone,
            createdAt: Constants.date,
            modifiedAt: Constants.date,
            color: Constants.color,
            categoryId: Constants.categoryId
        )
        XCTAssertEqual(todoItem.id, Constants.id)
        XCTAssertEqual(todoItem.text, Constants.text)
        XCTAssertEqual(todoItem.priority, Constants.priority)
        XCTAssertEqual(todoItem.deadline, Constants.date)
        XCTAssertFalse(todoItem.isDone)
        XCTAssertEqual(todoItem.createdAt, Constants.date)
        XCTAssertEqual(todoItem.modifiedAt, Constants.date)
        XCTAssertEqual(todoItem.color, Constants.color)
        XCTAssertEqual(todoItem.categoryId, Constants.categoryId)
    }

    func testInitWithDefaults() {
        let todoItem = TodoItem(
            text: Constants.text,
            priority: Constants.priority,
            isDone: true,
            createdAt: Constants.date
        )

        XCTAssertNotNil(todoItem.id)
        XCTAssertNotNil(UUID(uuidString: todoItem.id))
        XCTAssertEqual(todoItem.text, Constants.text)
        XCTAssertEqual(todoItem.priority, Constants.priority)
        XCTAssertTrue(todoItem.isDone)
        XCTAssertNil(todoItem.deadline)
        XCTAssertEqual(todoItem.createdAt, Constants.date)
        XCTAssertNil(todoItem.modifiedAt)
        XCTAssertNil(todoItem.color)
        XCTAssertNil(todoItem.categoryId)
    }

    func testJsonParse() {
        let jsonString = """
        {
            "id": "\(Constants.id)",
            "text": "\(Constants.text)",
            "is_done": \(Constants.isDone),
            "priority": "\(Constants.priority.rawValue)",
            "deadline": \(Constants.ts),
            "created_at": \(Constants.ts),
            "modified_at": \(Constants.ts),
            "color": "\(Constants.color!)",
            "category_id": "\(Constants.categoryId!)"
        }
        """
        testJsonParse(todoItem: Constants.TodoItems.full, jsonString: jsonString)
    }

    func testJsonParseOnlyRequiredFields() {
        let jsonString = """
        {
            "id": "\(Constants.id)",
            "text": "\(Constants.text)",
            "is_done": \(Constants.isDone),
            "created_at": \(Constants.ts)
        }
        """
        testJsonParse(todoItem: Constants.TodoItems.onlyRequired, jsonString: jsonString)
    }

    func testJsonCreation() {
        let todoItem = Constants.TodoItems.full
        let todoItemDict: [String: Any] = [
            TodoItem.Keys.id.rawValue: Constants.id,
            TodoItem.Keys.text.rawValue: Constants.text,
            TodoItem.Keys.priority.rawValue: Constants.priority.rawValue,
            TodoItem.Keys.deadline.rawValue: Constants.ts,
            TodoItem.Keys.isDone.rawValue: Constants.isDone,
            TodoItem.Keys.modifiedAt.rawValue: Constants.ts,
            TodoItem.Keys.createdAt.rawValue: Constants.ts,
            TodoItem.Keys.color.rawValue: Constants.color!,
            TodoItem.Keys.categoryId.rawValue: Constants.categoryId!
        ]
        guard let todoItemJson = todoItem.json as? [String: Any] else {
            XCTFail("todoItemJson is not [String: Any]")
            return
        }
        XCTAssertTrue(areDictsEqual(todoItemDict, todoItemJson))
    }

    func testJsonCreationOnlyRequiredFields() {
        let todoItem = Constants.TodoItems.onlyRequired
        let todoItemDict: [String: Any] = [
            TodoItem.Keys.id.rawValue: Constants.id,
            TodoItem.Keys.text.rawValue: Constants.text,
            TodoItem.Keys.isDone.rawValue: Constants.isDone,
            TodoItem.Keys.createdAt.rawValue: Constants.ts
        ]
        guard let todoItemJson = todoItem.json as? [String: Any] else {
            XCTFail("todoItemJson is not [String: Any]")
            return
        }
        XCTAssertTrue(areDictsEqual(todoItemDict, todoItemJson))
    }

    func testCSVParse() {
        let todoItem = Constants.TodoItems.full
        let csvString = "\(Constants.id),\(Constants.text),\(Constants.priority.rawValue)," +
        "\(Constants.ts),\(Constants.isDone),\(Constants.ts),\(Constants.ts),\(Constants.color!),\(Constants.categoryId!)"
        testCSVParse(todoItem: todoItem, csvString: csvString)
    }

    func testCSVParseOnlyRequiredFields() {
        let todoItem = Constants.TodoItems.onlyRequired
        let csvString = "\(Constants.id),\(Constants.text), , ,\(Constants.isDone),\(Constants.ts), ,\(Constants.color!)"
        testCSVParse(todoItem: todoItem, csvString: csvString)
    }

    func testCSVCreation() {
        let todoItem = Constants.TodoItems.full
        let csvString = "\(Constants.id),\(Constants.text),\(Constants.priority.rawValue)," +
        "\(Constants.ts),\(Constants.isDone),\(Constants.ts),\(Constants.ts),\(Constants.color!),\(Constants.categoryId!)"
        let todoItemCSV = todoItem.csv
        XCTAssertEqual(todoItemCSV, csvString)
    }

    func testCSVCreationOnlyRequiredFields() {
        let todoItem = Constants.TodoItems.onlyRequired
        let csvString = "\(Constants.id),\(Constants.text), , ,\(Constants.isDone),\(Constants.ts), , , "
        let todoItemCSV = todoItem.csv
        XCTAssertEqual(todoItemCSV, csvString)
    }

    // MARK: - Private methods
    private func areDictsEqual(_ dict1: [String: Any], _ dict2: [String: Any]) -> Bool {
        return dict1[TodoItem.Keys.id.rawValue] as? String == dict2[TodoItem.Keys.id.rawValue] as? String &&
            dict1[TodoItem.Keys.text.rawValue] as? String == dict2[TodoItem.Keys.text.rawValue] as? String &&
            dict1[TodoItem.Keys.priority.rawValue] as? String == dict2[TodoItem.Keys.priority.rawValue] as? String &&
            dict1[TodoItem.Keys.isDone.rawValue] as? Bool == dict2[TodoItem.Keys.isDone.rawValue] as? Bool &&
            dict1[TodoItem.Keys.deadline.rawValue] as? TimeInterval == dict2[TodoItem.Keys.deadline.rawValue] as? TimeInterval &&
            dict1[TodoItem.Keys.modifiedAt.rawValue] as? TimeInterval == dict2[TodoItem.Keys.modifiedAt.rawValue] as? TimeInterval &&
            dict1[TodoItem.Keys.createdAt.rawValue] as? TimeInterval == dict2[TodoItem.Keys.createdAt.rawValue] as? TimeInterval &&
            dict1[TodoItem.Keys.color.rawValue] as? String == dict2[TodoItem.Keys.color.rawValue] as? String
    }

    private func testJsonParse(todoItem: TodoItem, jsonString: Any) {
        let parsedString = TodoItem.parse(json: jsonString)
        guard let parsedString else {
            XCTFail("Error while parsing jsonString")
            return
        }
        XCTAssertNotNil(parsedString)
        XCTAssertEqual(todoItem, parsedString)
    }

    private func testCSVParse(todoItem: TodoItem, csvString: String) {
        let parsedString = TodoItem.parse(csv: csvString)
        guard let parsedString else {
            XCTFail("Error while parsing csvString")
            return
        }
        XCTAssertNotNil(parsedString)
        XCTAssertEqual(todoItem, parsedString)
    }

}
// swiftlint:enable line_length
