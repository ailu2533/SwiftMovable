//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/27.
//

import SwiftUI

public struct MovableObjectView<Item: MovableObject, Content: View>: View {
    // MARK: - Properties

    @Bindable var item: Item
    @Binding var selection: UUID?
    private var config: MovableObjectViewConfig
    var content: (Item) -> Content

    @State private var viewSize: CGSize = .zero
    @State private var lastFeedbackAngle: Double = 0
    @State private var currentAngle: Angle = .zero
    @State private var isDragging = false
    @State private var lastRotationUpdateTime: Date = Date()
    @State private var rotationDegrees = 0.0

    private let id = UUID()
    let offset: CGFloat = 20
    let snapThreshold: Double = 2
    let smallRotationThreshold: Double = 5

    var selected: Bool { selection == item.id }
    var showControl: Bool { selected && config.enable }

    // MARK: - Initializer

    public init(item: Item, selection: Binding<UUID?>, config: MovableObjectViewConfig, content: @escaping (Item) -> Content) {
        self.item = item
        self.config = config
        self.content = content
        _selection = selection
    }

    // MARK: - Rotation Methods

    public func calculateRotation(value: DragGesture.Value) -> Angle {
        let centerX = viewSize.width / 2
        let centerY = viewSize.height / 2
        let startVector = CGVector(dx: value.startLocation.x - centerX, dy: value.startLocation.y - centerY)
        let endVector = CGVector(dx: value.location.x - centerX, dy: value.location.y - centerY)
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        return Angle(radians: Double(angleDifference))
    }

    func updateRotation(value: DragGesture.Value) -> Angle {
        return calculateRotation(value: value)
    }

    // MARK: - UI Components

    var editButton: some View {
        Button(action: { config.editCallback(item) }) {
            Image(systemName: "pencil.tip")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
        }
        .offset(x: offset, y: -offset)
        .opacity(showControl ? 1 : 0)
        .buttonStyle(CircleButtonStyle2())
    }

    var deleteButton: some View {
        Button(role: .destructive, action: { config.deleteCallback(item) }) {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
        }
        .offset(x: -offset, y: -offset)
        .opacity(showControl ? 1 : 0)
        .buttonStyle(CircleButtonStyle2())
    }

    var rotationHandler: some View {
        let dragGesture = DragGesture(coordinateSpace: .named(id))
            .onChanged { value in
                let now = Date()
                let timeInterval = now.timeIntervalSince(lastRotationUpdateTime)
                guard timeInterval > 0.016 else { return }

                lastRotationUpdateTime = now
                currentAngle = updateRotation(value: value)
                rotationDegrees = item.rotationDegree + currentAngle.degrees
            }
            .onEnded { _ in
                item.rotationDegree += currentAngle.degrees
                currentAngle = .zero

                if abs(item.rotationDegree - 0) <= snapThreshold {
                    item.rotationDegree = .zero
                }
            }

        return Image(systemName: "arrow.triangle.2.circlepath")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 12, height: 12)
            .padding(5)
            .background(isDragging ? Color.orange : Color.white)
            .clipShape(Circle())
            .shadow(radius: 1)
            .frame(width: 50, height: 50)
            .contentShape(Rectangle())
            .opacity(showControl ? 1 : 0)
            .offset(y: 2 * offset)
            .if(config.enable) { view in
                view.gesture(dragGesture)
            }
    }

    var topCorner: some View {
        Rectangle()
            .stroke(Color.cyan, style: StrokeStyle(lineWidth: 1.5))
            .opacity(showControl ? 1 : 0)
            .readSize(callback: { viewSize = $0 })
            .overlay(alignment: .topTrailing) { editButton }
            .overlay(alignment: .topLeading) { deleteButton }
            .if(showControl) { view in
                view.modifier(DraggableModifier(width: $item.width, height: $item.height, hasBorder: false))
            }
            .background(alignment: .bottom) { rotationHandler }
    }

    // MARK: - Gestures

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let locationX = value.location.x
                let locationY = value.location.y
                if let parentSize = config.parentSize {
                    if locationX < 0 || locationY < 0 || locationX > parentSize.width || locationY > parentSize.height {
                        return
                    }
                }
                print(value.location)
                item.onDragChanged(translation: value.translation)
            }
            .onEnded { _ in
                item.onDragEnd()
            }
    }

    // MARK: - Body

    public var body: some View {
        content(item)
            .if(item.width > 0 && item.height > 0) { view in
                view.frame(width: item.width, height: item.height)
            }
            .padding(4)
            .anchorPreference(key: ViewSizeKey.self, value: .center, transform: { $0 })
            .contentShape(Rectangle())
            .overlay { topCorner }
            .rotationEffect(currentAngle + Angle(degrees: item.rotationDegree))
            .coordinateSpace(name: id)
            .position(x: item.pos.x, y: item.pos.y)
            .offset(x: item.offset.x, y: item.offset.y)
            .if(config.enable && selection == item.id) { view in
                view.gesture(dragGesture)
            }
            .onTapGesture {
                config.tapCallback(item)
                selection = item.id
            }
            .zIndex(selection == item.id ? 1 : 0)
            .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.6), trigger: rotationDegrees) { oldValue, newValue in
                abs(oldValue) >= snapThreshold && abs(newValue) < snapThreshold
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
