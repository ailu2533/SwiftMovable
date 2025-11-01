//
//  RotationViewModifier.swift
//
//
//  Created by ailu on 2024/7/13.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry public var canvasCoordinateSpace: String = "default"
}

let kOffset: CGFloat = 16

// MARK: - MovableViewModifier

struct MovableViewModifier<Item: MovableObject>: ViewModifier {
    // MARK: Internal

    @Binding var currentRotation: Angle
    @Binding var position: CGPoint

    @Binding var height: CGFloat
    @Binding var width: CGFloat

    var isSelected = false
    var config: MovableObjectViewConfig<Item>
    var item: Item

    @Environment(\.canvasCoordinateSpace)
    private var coordinateSpace

    func body(content: Content) -> some View {
        content
            // 缩放
            .frame(width: width * pinchMagnification, height: height * pinchMagnification)
            .padding(4)
            .border(isSelected ? .purple : .clear, width: 2)
            .contentShape(Rectangle())
            .overlay(alignment: .bottom) {
                Image(systemName: "arrow.clockwise")
                    .iconStyle()
                    .offset(y: 44)
                    .gesture(rotationDragGesture)
                    .opacity(isSelected ? 1 : 0)
            }
            .if(isSelected && config.isResizable) { view in
                view.modifier(
                    DraggableModifier(
                        width: $width,
                        height: $height,
                        hasBorder: true,
                        item: item,
                        onResize: config.onResize
                    )
                )
            }
            .overlay(alignment: .topLeading) {
                Button {
                    config.onDelete(item)
                } label: {
                    Image(systemName: "trash")
                        .iconStyle()
                }
                .offset(x: -kOffset, y: -kOffset)
                .opacity(isSelected ? 1 : 0)
            }
//             旋转
            .rotationEffect(currentRotation + twistAngle)
//             移动
            .position(position)
            .offset(offset)
            .gesture(moveGesture)
            .gesture(
                rotationGesture
                    .simultaneously(with: magnificationGesture)
            )
    }

    // MARK: Private

    // 旋转
    @State private var twistAngle: Angle = .zero

    // 缩放
    @State private var pinchMagnification: CGFloat = 1

    // 位置
    @State private var offset: CGSize = .zero

    private var moveGesture: some Gesture {
        DragGesture(coordinateSpace: .named(coordinateSpace))
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                position = .init(x: position.x + offset.width, y: position.y + offset.height)
                offset = .zero
            }
    }

    private var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged { value in
                twistAngle = value
            }
            .onEnded { _ in
                currentRotation += twistAngle
                twistAngle = .zero
            }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                pinchMagnification = value
            }
            .onEnded { _ in
                width *= pinchMagnification
                height *= pinchMagnification
                pinchMagnification = 1
            }
    }

    private var rotationDragGesture: some Gesture {
        DragGesture(coordinateSpace: .named(coordinateSpace))
            .onChanged { value in
                twistAngle = calculateRotation(value: value)
            }
            .onEnded { _ in
                currentRotation += twistAngle
                twistAngle = .zero
            }
    }

    private func calculateRotation(value: DragGesture.Value) -> Angle {
        let center = position
        let startVector = value.startLocation - center
        let endVector = value.location - center
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        return Angle(radians: angleDifference)
    }
}
