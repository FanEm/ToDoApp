//
//  URLSessionTests.swift
//  ToDoTests
//
//  Created by Artem Novikov on 11.07.2024.
//

import XCTest
@testable import ToDo

final class URLSessionTests: XCTestCase {

    private struct CatFactDTO: Codable {
        let fact: String
        let length: Int
    }

    private var url: URL = URL(string: "https://catfact.ninja/fact")!

    func testGetRequest() async throws {
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.dataTask(for: request)
            XCTAssertNotNil(response)
            XCTAssertNotNil(data)
            let catFact = try? JSONDecoder().decode(CatFactDTO.self, from: data)
            XCTAssertNotNil(catFact)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCancelRequest() async {
        let expectation = expectation(description: "Request should be cancelled")
        let request = URLRequest(url: url)
        let task = Task {
            do {
                let (_, _) = try await URLSession.shared.dataTask(for: request)
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
