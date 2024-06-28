//
//  InfoSwipe.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import SwiftUI

// MARK: - InfoSwipe
struct InfoSwipe: ViewModifier {

    var onAction: () -> Void

    func body(content: Content) -> some View {
        content.swipeActions(edge: .trailing) {
            Button {
                onAction()
            } label: {
                Label("info", systemImage: "info.circle.fill")
            }
            .tint(.primaryLightGray)
        }
    }

}
