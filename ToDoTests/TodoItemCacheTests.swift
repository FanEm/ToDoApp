//
//  TodoItemCacheTests.swift
//  ToDoTests
//
//  Created by Artem Novikov on 15.06.2024.
//

import XCTest
@testable import ToDo

final class TodoItemCacheTests: XCTestCase {

    private enum Constants {
        static let date = Date(timeIntervalSince1970: 1718465615)
        nonisolated(unsafe) static let item1 = TodoItem(
            text: "item1",
            importance: .low,
            deadline: date,
            isDone: false,
            createdAt: date,
            modifiedAt: date
        )
        nonisolated(unsafe) static let item2 = TodoItem(
            text: "item2",
            importance: .basic,
            isDone: true,
            createdAt: date
        )
        enum FileName {
            static let json = "items.json"
            static let csv = "items.csv"
        }
    }

    private let fileCache = TodoItemCache.shared

    override class func setUp() {
        super.setUp()
        TodoItemCache.shared.removeAllItems()
    }

    override func tearDown() {
        super.tearDown()
        fileCache.removeAllItems()
    }

    func testAddItemAndRemove() {
        for item in [Constants.item1, Constants.item2] {
            fileCache.addItem(item)
        }
        XCTAssertEqual(fileCache.items.count, 2)
        XCTAssertEqual(fileCache.items[Constants.item1.id], Constants.item1)
        XCTAssertEqual(fileCache.items[Constants.item2.id], Constants.item2)
        fileCache.removeItem(id: Constants.item1.id)
        XCTAssertEqual(fileCache.items.count, 1)
        XCTAssertEqual(fileCache.items[Constants.item2.id], Constants.item2)
        fileCache.removeItem(id: Constants.item2.id)
        XCTAssertEqual(fileCache.items.count, 0)
    }

    func testAddExistedItem() {
        fileCache.addItem(Constants.item1)
        XCTAssertEqual(fileCache.items.count, 1)
        XCTAssertEqual(fileCache.items[Constants.item1.id], Constants.item1)
        fileCache.addItem(Constants.item1)
        XCTAssertEqual(fileCache.items.count, 1)
        XCTAssertEqual(fileCache.items[Constants.item1.id], Constants.item1)
    }

    func testSaveAndLoadJson() {
        for item in [Constants.item1, Constants.item2] {
            fileCache.addItem(item)
        }
        do {
            try fileCache.saveJson(to: Constants.FileName.json)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        XCTAssertEqual(fileCache.items.count, 2)
        XCTAssertEqual(fileCache.items[Constants.item1.id], Constants.item1)
        XCTAssertEqual(fileCache.items[Constants.item2.id], Constants.item2)
        fileCache.removeAllItems()
        XCTAssertEqual(fileCache.items.count, 0)
        do {
            try fileCache.loadJson(from: Constants.FileName.json)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        XCTAssertEqual(fileCache.items.count, 2)
        XCTAssertEqual(fileCache.items[Constants.item1.id], Constants.item1)
        XCTAssertEqual(fileCache.items[Constants.item2.id], Constants.item2)
    }

    func testSaveAndLoadCSV() {
        for item in [Constants.item1, Constants.item2] {
            fileCache.addItem(item)
        }
        do {
            try fileCache.saveCSV(to: Constants.FileName.csv)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        XCTAssertEqual(fileCache.items.count, 2)
        XCTAssertEqual(fileCache.items[Constants.item1.id], Constants.item1)
        XCTAssertEqual(fileCache.items[Constants.item2.id], Constants.item2)
        fileCache.removeAllItems()
        XCTAssertEqual(fileCache.items.count, 0)
        do {
            try fileCache.loadCSV(from: Constants.FileName.csv)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        XCTAssertEqual(fileCache.items.count, 2)
        XCTAssertEqual(fileCache.items[Constants.item1.id], Constants.item1)
        XCTAssertEqual(fileCache.items[Constants.item2.id], Constants.item2)
    }

}
