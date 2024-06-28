//
//  MarkAsDoneSwipe.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import SwiftUI

// MARK: - MarkAsDoneSwipe
struct MarkAsDoneSwipe: ViewModifier {

    var isDone: Bool
    var onAction: () -> Void

    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .leading) {
                Button(role: .cancel) {
                    onAction()
                } label: {
                    if isDone {
                        undoneLabel
                    } else {
                        doneLabel
                    }
                }
            }
    }

    private var doneLabel: some View {
        label(text: "done", tint: .primaryGreen, systemImage: "checkmark.circle.fill")
    }

    private var undoneLabel: some View {
        label(text: "undone", tint: .primaryRed, systemImage: "x.circle.fill")
    }

    private func label(text: LocalizedStringKey, tint: Color, systemImage: String) -> some View {
        Label(text, systemImage: systemImage).tint(tint)
    }

}
