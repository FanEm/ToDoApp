//
//  StorageService.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation
import UIKit

// MARK: - StorageService
final class StorageService: @unchecked Sendable {

    // MARK: - Public  properties
    static let shared = StorageService()

    var revision: Int {
        get {
            userDefaults.integer(forKey: Keys.revision.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.revision.rawValue)
        }
    }

    var defaultCategoriesAdded: Bool {
        get {
            userDefaults.bool(forKey: Keys.defaultCategoriesAdded.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.defaultCategoriesAdded.rawValue)
        }
    }

    // MARK: - Private  properties
    private enum Keys: String {
        case revision, defaultCategoriesAdded
    }

    private let userDefaults = UserDefaults.standard

    // MARK: - Initializers
    private init() {}

}
