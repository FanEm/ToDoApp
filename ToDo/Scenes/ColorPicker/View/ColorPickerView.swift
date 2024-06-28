//
//  ColorPickerView.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import SwiftUI

// MARK: - CustomColorPicker
struct CustomColorPicker: View {

    @Binding var selectedColor: Color
    @State var brightness: Double = 1.0
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                ColorPalette(
                    selectedColor: $selectedColor,
                    brightness: $brightness
                )
                ColorPickerSlider(
                    title: "colorPicker.brightness",
                    value: $brightness
                )
            }
            .padding()
            .navigationTitle("colorPicker.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundStyle(.backgroundPrimary, .textPrimary)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
            }
        }
    }

}

#Preview {
    @State var selectedColor1: Color = .white
    return CustomColorPicker(selectedColor: $selectedColor1)
}
