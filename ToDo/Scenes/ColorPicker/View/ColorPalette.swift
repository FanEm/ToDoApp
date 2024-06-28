//
//  ColorPalette.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import SwiftUI

// MARK: - ColorPalette
struct ColorPalette: View {

    @Binding var selectedColor: Color
    @Binding var brightness: Double

    @State private var currentPoint: CGPoint = .zero
    private let colorPointSize = CGSize(width: 20, height: 20)

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let rect = CGRect(origin: .zero, size: size)

            Canvas { context, size in
                for x in stride(from: 0, to: size.width, by: colorPointSize.width) {
                    for y in stride(from: 0, to: size.height, by: colorPointSize.height) {
                        let color = getColor(at: CGPoint(x: x, y: y), in: size)
                        context.fill(
                            Path(
                                CGRect(
                                    x: x, y: y,
                                    width: colorPointSize.width,
                                    height: colorPointSize.height
                                )
                            ),
                            with: .color(color)
                        )
                    }
                }
            }

            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = value.location
                        if rect.contains(point) {
                            currentPoint = point
                            updateColor(at: point, in: size)
                        }
                    }
            )
            .onChange(of: brightness) {
                updateColor(at: currentPoint, in: size)
            }
            .background(Color.clear)
            .overlay(
                Circle()
                    .stroke(.black, lineWidth: 1)
                    .fill(selectedColor)
                    .frame(width: 20, height: 20)
                    .position(currentPoint)
            )
        }
        .frame(minHeight: 100)
    }

    private func getColor(at point: CGPoint, in size: CGSize) -> Color {
        let hue = Double(point.x / size.width)
        let saturation = Double(point.y / size.height)
        return Color(
            hue: hue,
            saturation: saturation,
            brightness: brightness
        )
    }

    private func updateColor(at point: CGPoint, in size: CGSize) {
        selectedColor = getColor(at: point, in: size)
    }

}
