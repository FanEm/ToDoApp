//
//  ColorPickerSlider.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import SwiftUI

// MARK: - ColorPickerSlider
struct ColorPickerSlider: View {

    let title: LocalizedStringKey
    @Binding var value: Double

    var body: some View {
        HStack {
            Text(title)
                .frame(width: 100, alignment: .leading)
                .truncationMode(.tail)
                .lineLimit(1)
                .font(.todoHeadline)
                .foregroundStyle(.textSecondary)
            Slider(value: $value, in: 0...1)
                .tint(.primaryBlue)
        }
        .padding(.vertical)
    }

}
