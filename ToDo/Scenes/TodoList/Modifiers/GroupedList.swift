//
//  GroupedList.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import SwiftUI

// MARK: - GroupedList
struct GroupedList: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(.backgroundPrimary)
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
    }

}
