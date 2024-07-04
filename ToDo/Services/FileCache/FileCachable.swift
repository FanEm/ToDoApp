//
//  FileCachable.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

protocol StringIdentifiable: Identifiable where ID == String {}

protocol FileCachableJson {
    var json: Any { get }
    static func parse(json: Any) -> Self?
}

protocol FileCachableCsv {
    var csv: String { get }
    static var csvHeader: [String] { get }
    static func parse(csv: String) -> Self?
}

typealias FileCachable = StringIdentifiable & FileCachableJson & FileCachableCsv
