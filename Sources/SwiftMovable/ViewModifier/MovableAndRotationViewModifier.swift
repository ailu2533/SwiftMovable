//
//  File.swift
//
//
//  Created by ailu on 2024/7/13.
//

import Foundation
import SwiftUI

struct IconViewModifier: ViewModifier {
    var size: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .frame(width: size * 2, height: size * 2)
            .background(Color(.systemGray6))
            .clipShape(Circle())
            .shadow(radius: 1)
    }
}

extension View {
    func iconStyle(size: CGFloat = 10) -> some View {
        modifier(IconViewModifier(size: size))
    }
}

struct MovableAndRotationViewModifier: ViewModifier {
    @Binding var currentRotation: Angle
    @Binding var position: CGPoint

    var isSelected = false

    @State private var viewSize: CGSize = .zero

    // 旋转
    @State private var twistAngle: Angle = .zero

    // 位置
    @State private var offset: CGSize = .zero

    private let id = UUID()

    func body(content: Content) -> some View {
        content

            .readSize(callback: {
                viewSize = $0
            })
            .padding(4)
            .border(isSelected ? .cyan : .clear, width: 2)
            .contentShape(Rectangle())
            .overlay(alignment: .bottom, content: {
                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                    .iconStyle()
                    .offset(y: 25)
                    .gesture(rotationDragGesture)
                    .opacity(isSelected ? 1 : 0)
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

public struct MovableAndRotation: View {
    public init() {}

    @State private var currentRotation: Angle = .zero

    @State private var height: CGFloat = 100
    @State private var width: CGFloat = 100

    @State private var position: CGPoint = .init(x: 200, y: 200)

    public var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan.opacity(0.4), .yellow.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)

            Text("hello world")
                .modifier(
                    MovableAndRotationViewModifier(
                        currentRotation: $currentRotation,
                        position: $position,
                        isSelected: true
                    )
                )
        }
    }
}

#Preview {
    MovableAndRotation()
}
