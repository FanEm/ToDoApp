//
//  AnalyticsService.swift
//  ToDo
//
//  Created by Artem Novikov on 08.07.2024.
//

import Foundation

// MARK: - AnalyticsService
struct AnalyticsService {

    static func report(
        eventItem: AnalyticEventItem,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        Logger.info(
            "Event name: \(eventItem.eventName), data: \(eventItem.toDict)",
            file: file,
            function: function,
            line: line
        )
    }

}

// MARK: - TodoList
extension AnalyticsService {

    static func openTodoList(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .open, screen: .todoList),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListFilterShowCompleted(
        _ showCompleted: Bool,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(
                event: .click,
                screen: .todoList,
                item: showCompleted ? .hideCompleted : .showCompleted
            ),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListSortByImportance(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .todoList, item: .sortByImportance),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListSortByCreationDate(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .todoList, item: .sortByCreationDate),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListSwipeMarkAsCompleted(
        _ isCompleted: Bool,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(
                event: .swipe,
                screen: .todoList,
                item: isCompleted ? .markAsCompleted : .markAsIncompleted
            ),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListSwipeToDelete(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .swipe, screen: .todoList, item: .delete),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListSwipeInfo(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .swipe, screen: .todoList, item: .info),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListTapMarkAsCompleted(
        _ isCompleted: Bool,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(
                event: .click,
                screen: .todoList,
                item: isCompleted ? .markAsCompleted : .markAsIncompleted
            ),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListTapEditEvent(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .todoList, item: .edit),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListTapAddNewEvent(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .todoList, item: .addNew),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListTapQuickAddNewEvent(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .todoList, item: .quickAddNew),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoListTapCalendar(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .todoList, item: .calendar),
            file: file,
            function: function,
            line: line
        )
    }

}

// MARK: - Calendar
extension AnalyticsService {

    static func openCalendar(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .open, screen: .calendar),
            file: file,
            function: function,
            line: line
        )
    }

    static func closeCalendar(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .close, screen: .calendar),
            file: file,
            function: function,
            line: line
        )
    }

    static func calendarSwipeMarkAsCompleted(
        _ isCompleted: Bool,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(
                event: .swipe,
                screen: .calendar,
                item: isCompleted ? .markAsCompleted : .markAsIncompleted
            ),
            file: file,
            function: function,
            line: line
        )
    }

    static func calendarTapAddNew(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .calendar, item: .addNew),
            file: file,
            function: function,
            line: line
        )
    }

}

// MARK: - TodoView
extension AnalyticsService {

    static func openTodoView(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .open, screen: .todoView),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoViewSave(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .todoView, item: .save),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoViewCancel(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(event: .click, screen: .todoView, item: .cancel),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoViewDeadline(
        enabled: Bool,
        date: Date?,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        var params: [String: String] = ["enabled": "\(enabled)"]
        if let date {
            params["date"] = date.formatted(.iso8601)
        }
        report(
            eventItem: AnalyticEventItem(
                event: .click,
                screen: .todoView,
                item: .deadline,
                params: params
            ),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoViewImportance(
        _ importance: String,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(
                event: .click,
                screen: .todoView,
                item: .importance,
                params: ["importance": importance]
            ),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoViewCategory(
        _ categoryId: String?,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(
                event: .click,
                screen: .todoView,
                item: .category,
                params: ["categoryId": categoryId ?? "nil"]
            ),
            file: file,
            function: function,
            line: line
        )
    }

    static func todoViewDelete(
        id: String,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        report(
            eventItem: AnalyticEventItem(
                event: .click, screen: .todoView, item: .delete, params: ["id": id]
            ),
            file: file,
            function: function,
            line: line
        )
    }

}
