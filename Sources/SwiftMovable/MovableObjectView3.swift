//
//  File.swift
//  SwiftMovable
//
//  Created by ailu on 2024/7/17.
//

import Foundation
import SwiftUI

public struct MovableObjectView3<Item: MovableObject, Content: View>: View {
//    @Environment(DraggingState.self) private var draggingState

    var item: Item
    @Binding var selection: MovableObject?
    private var config: MovableObjectViewConfig
    var content: (Item) -> Content

    @State private var viewSize: CGSize = .zero
    @GestureState private var angle: Angle = .zero
    let offset: CGFloat = 20

    @GestureState private var isDragging = false
    private let id = UUID()

    @GestureState private var translation: CGSize = .zero
    @State private var translationState: CGSize = .zero

    var selected: Bool {
        selection?.id == item.id
    }

    var showControl: Bool {
        return selected && config.isEnabled
    }

//    var parentCoordinateSpaceID: UUID

    public init(item: Item, selection: Binding<MovableObject?>, config: MovableObjectViewConfig, content: @escaping (Item) -> Content) {
//        self.parentCoordinateSpaceID = confi
        self.item = item
        self.config = config
        self.content = content
        _selection = selection

//        LoggingUtils.movable.debug("\(item.debugText)")
    }

    public func calculateRotation(value: DragGesture.Value) -> Angle {
        let centerX = viewSize.width / 2
        let centerY = viewSize.height / 2
        let startVector = CGVector(dx: value.startLocation.x - centerX, dy: value.startLocation.y - centerY)
        let endVector = CGVector(dx: value.location.x - centerX, dy: value.location.y - centerY)
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        return Angle(radians: Double(angleDifference))
    }

    var editButton: some View {
        Button(action: {
            config.onEdit(item)
        }, label: {
            Image(systemName: "pencil.tip")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
        })
        .offset(x: offset, y: -offset)
        .opacity(showControl ? 1 : 0)
        .buttonStyle(CircleButtonStyle2())
    }

    var deleteButton: some View {
        Button(role: .destructive, action: {
            config.onDelete(item)
        }, label: {
            Image(systemName: "trash")
                .imageScale(.medium)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 12, height: 12)
        })
        .offset(y: -2 * offset)
        .opacity(showControl ? 1 : 0)
        .buttonStyle(CircleButtonStyle2())
    }

    var rotationHandler: some View {
        let dragGesture = DragGesture(coordinateSpace: .named(id))
            .updating($angle, body: { value, state, _ in
                state = calculateRotation(value: value)
            })
            .updating($isDragging, body: { _, state, _ in
                state = true
            })

            .onEnded({ value in
                item.rotationDegree += calculateRotation(value: value).degrees
            })

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
            .if(config.isEnabled) { view in
                view.gesture(dragGesture)
            }
    }

    var topCorner: some View {
        return Rectangle()
            .stroke(lineWidth: 1.0)
//            .shadow(color: Color(.systemBackground), radius: 0.1)
            .foregroundStyle(Color(.blue))
//            .shadow(radius: 10)
            .opacity(showControl ? 1 : 0)
            .readSize(callback: {
                viewSize = $0
            })
//            .overlay(alignment: .topTrailing) {
//                editButton
//            }
            .overlay(alignment: .top) {
                deleteButton
            }
//            .background(alignment: .bottom) {
//                rotationHandler
//            }
    }

    private func isWithinBounds(x: CGFloat, y: CGFloat, parentSize: CGSize) -> Bool {
        return !(x < 0 || y < 0 || x > parentSize.width || y > parentSize.height)
    }

    @State private var lastUpdateTime = Date()

    private var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging, body: { _, state, _ in
                state = true
            })
            .onChanged({ value in
                let now = Date()
                let timeInterval = now.timeIntervalSince(lastUpdateTime)
                guard timeInterval > 0.017 else {
//                    Logging.shared.debug("节流: \(timeInterval)")
                    return
                }

                lastUpdateTime = now

                let x = value.location.x
                let y = value.location.y

                var translation = value.translation

                if let parentSize = config.parentSize, !isWithinBounds(x: x, y: y, parentSize: parentSize) {
                    return
                }

                if let parentSize = config.parentSize {
                    let centerX = parentSize.width / 2
                    let centerY = parentSize.height / 2
                    let snapThreshold: CGFloat = 5

                    if abs(item.pos.x - centerX) < 2 && abs(translation.width) < snapThreshold {
                        translation.width = 0
                    }

                    if abs(item.pos.y - centerY) < 2 && abs(translation.height) < snapThreshold {
                        translation.height = 0
                    }
                }

                item.onDragChanged(translation: translation)
            })
            .onEnded({ _ in
                var finalX = item.pos.x + item.offset.x
                var finalY = item.pos.y + item.offset.y

                // 使用辅助函数来简化位置更新逻辑
                if let parentSize = config.parentSize {
                    let centerX = parentSize.width / 2
                    let centerY = parentSize.height / 2
                    let snapThreshold: CGFloat = 3

                    finalX = snapToCenter(value: finalX, center: centerX, snapThreshold: snapThreshold)
                    finalY = snapToCenter(value: finalY, center: centerY, snapThreshold: snapThreshold)
                }

                item.pos = CGPoint(x: finalX, y: finalY)

                // 重置偏移量
                item.offset = .zero
            })
    }

    // 定义一个辅助函数来处理吸附逻辑
    private func snapToCenter(value: CGFloat, center: CGFloat, snapThreshold: CGFloat) -> CGFloat {
        if abs(value - center) <= snapThreshold {
            return center
        }
        return value
    }

    public var body: some View {
        content(item)
            .anchorPreference(key: ViewSizeKey.self, value: .center, transform: { $0 })
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
            .background {
                topCorner
            }
//            .overlay(alignment: .top, content: {
//                GeometryReader(content: { geometry in
//                    let pos = geometry.frame(in: .global)
//                    Text("\(String(format: "%.1f", pos.minX)) \(String(format: "%.1f", pos.minY))")
//                        .offset(y: -20)
//                })
//            })

            .rotationEffect(angle + Angle(degrees: item.rotationDegree))
            .coordinateSpace(name: id)
            .position(x: item.pos.x, y: item.pos.y)
            .offset(x: item.offset.x, y: item.offset.y)
//            .if(config.enable && selection == item) { view in
//                view.highPriorityGesture(dragGesture)
//            }
            .onTapGesture {
                config.onTap(item)
                selection = item
            }
//            .zIndex(selection == item ? 1 : 0)
            .onChange(of: isDragging) { _, newValue in
//                draggingState.isDragging = newValue
//                print("isDragging 1: \(newValue)")
            }
    }
}

#Preview("3") {
    VStack {
        RoundedRectangle(cornerRadius: 8)
            .fill(.blue.opacity(0.2))
            .frame(height: 400)
            .overlay {
//                MovableObjectView3(item: MovableImage(pos: .init(x: 100, y: 100)), selected: true) { item in
//                    Image(systemName: item.imageName)
//                }
                
                MovableObjectView3(item: MovableImage(pos: .init(x: 100, y: 100)), selection: .constant(nil), config: MovableObjectViewConfig.Builder().build()) { item in
                    Image(systemName: item.imageName)
                        .resizable()
                        .scaledToFit()
                }
                
            }

//        MovableObjectView3(textItem: MovableImage(pos: .init(x: 100, y: 100)), selected: true) { item in
//            Image(systemName: item.imageName)
//                .resizable()
//                .frame(width: 50, height: 50)
//        }
    }
}
