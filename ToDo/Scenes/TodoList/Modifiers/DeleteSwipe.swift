//
//  DeleteSwipe.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import SwiftUI

// MARK: - DeleteSwipe
struct DeleteSwipe: ViewModifier {

    var onAction: () -> Void

    func body(content: Content) -> some View {
        content.swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onAction()
            } label: {
                Label("delete", systemImage: "trash")
            }
            .tint(.primaryRed)
        }
    }

}
