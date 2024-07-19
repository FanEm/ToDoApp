//
//  NetworkingServiceTests.swift
//  ToDoTests
//
//  Created by Artem Novikov on 11.07.2024.
//

import XCTest
@testable import ToDo

final class NetworkingServiceTests: XCTestCase {

    let networkingService = DefaultNetworkingService()

    enum Constants {
        static let id: String = UUID().uuidString
    }

    func testGetTodoList() async throws {
        let request = GetTodoItemListRequest()
        do {
            let data = try await networkingService.send(
                request: request,
                type: TodoItemListResponseModel.self
            )
            XCTAssertNotNil(data)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @MainActor
    func testCancelRequest() async {
        let expectation = expectation(description: "Request should be cancelled")
        let request = GetTodoItemListRequest()
        let task = Task {
            do {
                _ = try await networkingService.send(
                    request: request,
                    type: TodoItemListResponseModel.self
                )
                XCTFail("Request has not been cancelled")
            } catch is CancellationError {
                expectation.fulfill()
            } catch {
                XCTFail("Error: \(error)")
            }
        }
        task.cancel()
        await fulfillment(of: [expectation], timeout: 5.0)
    }

}
