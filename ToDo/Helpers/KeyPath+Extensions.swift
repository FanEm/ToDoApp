//
//  KeyPath+Extensions.swift
//  ToDo
//
//  Created by Artem Novikov on 12.07.2024.
//

// https://github.com/swiftlang/swift/issues/57560
#if compiler(<6.0) || !hasFeature(InferSendableFromCaptures)
extension KeyPath: @unchecked Sendable {}
#endif
