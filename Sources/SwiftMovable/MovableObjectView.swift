//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/27.
//

import SwiftUI

public struct CircleButtonStyle2: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    public init() {
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(5)
//            .foregroundStyle(configuration.role == .destructive ? .red : .white)
            .clipShape(Circle())
//            .shadow(radius: 1)
            .saturation(isEnabled ? 1 : 0)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .frame(width: 30, height: 30)
            .contentShape(Rectangle())
    }
}

public struct MovableObjectView<Item: MovableObject, Content: View>: View {
    @Bindable var item: Item

    private var content: (Item) -> Content
    private var selected: Bool
    private var deleteCallback: (Item) -> Void
    private var editCallback: (Item) -> Void

    @State private var viewSize: CGSize = .zero
    @GestureState private var angle: Angle = .zero

    public init(textItem: Item, selected: Bool, deleteCallback: @escaping (Item) -> Void, editCallback: @escaping (Item) -> Void, content: @escaping (Item) -> Content) {
        item = textItem
        self.selected = selected
        self.deleteCallback = deleteCallback
        self.editCallback = editCallback
        self.content = content
    }

    public init(textItem: Item, selected: Bool, content: @escaping (Item) -> Content) {
        item = textItem
        self.selected = selected
        deleteCallback = { _ in }
        editCallback = { _ in }
        self.content = content
    }

    private let id = UUID()

    public func calculateRotation(value: DragGesture.Value) -> Angle {
        let centerX = viewSize.width / 2
        let centerY = viewSize.height / 2
        let startVector = CGVector(dx: value.startLocation.x - centerX, dy: value.startLocation.y - centerY)
        let endVector = CGVector(dx: value.location.x - centerX, dy: value.location.y - centerY)
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        let rotation = Angle(radians: Double(angleDifference))

        return rotation
    }

    var topCorner: some View {
        return Rectangle()
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
            .shadow(color: Color(.black), radius: 0.1)
            .foregroundStyle(Color(.systemBackground))
            .shadow(radius: 10)
            .opacity(selected ? 1 : 0)
            .readSize(callback: {
                viewSize = $0
            })

            .overlay(alignment: .center) {
                Button(action: {
                    editCallback(item)
                }, label: {
                    Image(systemName: "pencil.tip")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                })
                .offset(x: viewSize.width / 2 + 10, y: -viewSize.height / 2 - 10)
                .opacity(selected ? 1 : 0)
                .buttonStyle(CircleButtonStyle2())
            }
            .overlay(alignment: .center) {
                Button(role: .destructive, action: {
                    deleteCallback(item)
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                })
                .offset(x: -viewSize.width / 2 - 10, y: -viewSize.height / 2 - 10)

                .opacity(selected ? 1 : 0)
                .buttonStyle(CircleButtonStyle2())
            }

            .background(alignment: .center) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .padding(5)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 1)

                    .opacity(selected ? 1 : 0)

                    .offset(x: viewSize.width / 2 + 10, y: viewSize.height / 2 + 10)

                    .gesture(
                        DragGesture(coordinateSpace: .named(id))
                            .updating($angle, body: { value, state, _ in
//                                print(value.location)
                                state = calculateRotation(value: value)
                            })
                            .onEnded({ value in
                                item.rotationDegree = item.rotationDegree + calculateRotation(value: value).degrees
                            })
                    )
            }
    }

    public var body: some View {
        content(item)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                topCorner
            }
            .rotationEffect(angle + Angle(degrees: item.rotationDegree))
            .coordinateSpace(name: id)
            .position(x: item.pos.x, y: item.pos.y)
            .offset(x: item.offset.x, y: item.offset.y)
            .gesture(DragGesture()
                .onChanged({ value in
                    item.onDragChanged(translation: value.translation)
                }).onEnded({ _ in
                    item.onDragEnd()
                })
            )
    }
}

class MovableImage: MovableObject {
    var imageName: String = "plus"
}

#Preview("3") {
    VStack {
        RoundedRectangle(cornerRadius: 8)
            .fill(.blue.opacity(0.2))
            .frame(height: 400)
            .overlay {
                MovableObjectView(textItem: MovableImage(pos: .init(x: 100, y: 100)), selected: true) { item in
                    Image(systemName: item.imageName)
                }
            }

        MovableObjectView(textItem: MovableImage(pos: .init(x: 100, y: 100)), selected: true) { item in
            Image(systemName: item.imageName)
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}
