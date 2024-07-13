//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/27.
//

import SwiftUI

struct RotationViewModifier: ViewModifier {
    @State private var viewSize: CGSize = .zero
    @State private var currentAngle: Angle = .zero
    @State private var rotationDegrees = 0.0
    private let id = UUID()

    // MARK: - Rotation Methods

    public func calculateRotation(value: DragGesture.Value) -> Angle {
        let centerX = viewSize.width / 2
        let centerY = viewSize.height / 2
        let startVector = CGVector(dx: value.startLocation.x - centerX, dy: value.startLocation.y - centerY)
        let endVector = CGVector(dx: value.location.x - centerX, dy: value.location.y - centerY)
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        return Angle(radians: Double(angleDifference))
    }

    private var rotateGesture: some Gesture {
        DragGesture()
            .onChanged { value in

                currentAngle = calculateRotation(value: value)
                rotationDegrees += currentAngle.degrees
            }
            .onEnded { _ in
                rotationDegrees += currentAngle.degrees
                currentAngle = .zero
            }
    }

    func body(content: Content) -> some View {
        content

            .background(alignment: .bottom, content: {
                Image(systemName: "arrow.clockwise")
                    .gesture(rotateGesture)
                    .offset(y: 20)
            })
            .readSize(callback: { viewSize = $0 })
            .rotationEffect(currentAngle + Angle(degrees: rotationDegrees))
    }
}

public struct MovableObjectView<Item: MovableObject, Content: View>: View {
    // MARK: - Properties

    @Bindable var item: Item
    @Binding var selection: UUID?
    private var config: MovableObjectViewConfig
    var content: (Item) -> Content

    var selected: Bool { selection == item.id }
    var showControl: Bool { selected && config.enable }

    // MARK: - Initializer

    public init(item: Item, selection: Binding<UUID?>, config: MovableObjectViewConfig, content: @escaping (Item) -> Content) {
        self.item = item
        self.config = config
        self.content = content
        _selection = selection
    }

    // MARK: - Body

    public var body: some View {
        content(item)
            .frame(width: item.width, height: item.height)
            .background(.red)
            .padding(4)
            .contentShape(Rectangle())
            .modifier(DraggableModifier(width: $item.width, height: $item.height, hasBorder: false))
            .modifier(RotationViewModifier())
            .modifier(MovableModifier())

            .onTapGesture {
                config.tapCallback(item)
                selection = item.id
            }
    }
}

class MovableImage: MovableObject {
    var imageName: String = "plus"
}

#Preview("3") {
    MovablePreview()
}

struct MovablePreview: View {
    @State private var selected: UUID?

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.blue.opacity(0.2))
                .frame(height: 400)
                .overlay {
                    MovableObjectView(item: MovableImage(pos: .init(x: 100, y: 100)), selection: $selected, config: MovableObjectViewConfig()) { item in
                        Image(systemName: item.imageName)
                    }
                }
        }
    }
}
