//
//  Int+Extensions.swift
//  ToDo
//
//  Created by Artem Novikov on 16.07.2024.
//

extension Int {

    init?(_ source: Double?) {
        guard let source else { return nil }
        self.init(source)
    }

}
