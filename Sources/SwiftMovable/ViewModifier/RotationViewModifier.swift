//
//  File.swift
//
//
//  Created by ailu on 2024/7/13.
//

import Foundation
import SwiftUI

struct MovableViewModifier: ViewModifier {
    @Binding var currentRotation: Angle
    @Binding var position: CGPoint

    @Binding var height: CGFloat
    @Binding var width: CGFloat

    var isSelected = false

    @State private var viewSize: CGSize = .zero

    // 旋转
    @State private var twistAngle: Angle = .zero

    // 缩放
    @State private var pinchMagnification: CGFloat = 1

    // 位置
    @State private var offset: CGSize = .zero

    private let id = UUID()

    func body(content: Content) -> some View {
        content
            // 缩放
            .frame(width: width * pinchMagnification, height: height * pinchMagnification)

            .readSize(callback: {
                viewSize = $0
            })
            .padding(4)
            .border(isSelected ? .cyan : .clear, width: 2)
            .contentShape(Rectangle())
            .if(isSelected, transform: { view in
                view.overlay(alignment: .bottom, content: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.red.opacity(0.4))
                        .frame(width: 40, height: 40)
                        .offset(y: 20)
                        .gesture(rotationDragGesture)
                })
            })
            .if(isSelected, transform: { view in
                view.modifier(DraggableModifier(width: $width, height: $height, hasBorder: true))

            })

//             旋转
            .rotationEffect(currentRotation + twistAngle)
//             移动
            .coordinateSpace(name: id)

            .position(position)
            .offset(offset)

            .gesture(dragGesture)
            .gesture(
                rotationGesture
                    .simultaneously(with: magnificationGesture)
            )
    }

    private var dragGesture: some Gesture {
        DragGesture()
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
            .onChanged({ value in
                twistAngle = value
            })

            .onEnded { _ in
                currentRotation += twistAngle
                twistAngle = .zero
            }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged({ value in
                pinchMagnification = value
            })

            .onEnded { _ in
                width *= pinchMagnification
                height *= pinchMagnification
                pinchMagnification = 1
            }
    }

    private var rotationDragGesture: some Gesture {
        return DragGesture(coordinateSpace: .named(id))

            .onChanged({ value in
                twistAngle = calculateRotation(value: value)
            })

            .onEnded { _ in
                currentRotation += twistAngle
                twistAngle = .zero
            }
    }

    public func calculateRotation(value: DragGesture.Value) -> Angle {
        let centerX = viewSize.width / 2
        let centerY = viewSize.height / 2
        let startVector = CGVector(dx: value.startLocation.x - centerX, dy: value.startLocation.y - centerY)
        let endVector = CGVector(dx: value.location.x - centerX, dy: value.location.y - centerY)
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        return Angle(radians: angleDifference)
    }
}

public struct RotationPreview: View {
    public init() {}

    @State private var currentRotation: Angle = .zero

    @State private var height: CGFloat = 100
    @State private var width: CGFloat = 100

    @State private var position: CGPoint = .init(x: 200, y: 200)

    public var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan.opacity(0.4), .yellow.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)

            Rectangle()
                .fill(.blue.opacity(0.4))
                .modifier(
                    MovableViewModifier(
                        currentRotation: $currentRotation,
                        position: $position,
                        height: $height,
                        width: $width
                    )
                )
        }
    }
}

#Preview {
    RotationPreview()
}
