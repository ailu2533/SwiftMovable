//
//  DraggableModifier.swift
//
//
//  Created by ailu on 2024/7/3.
//

import Foundation

import SwiftUI

// MARK: - NodePosition

enum NodePosition {
    case topLeft, topRight, bottomLeft, bottomRight
    case top // 上
    case bottom // 下
    case left // 左
    case right // 右
}

// MARK: - DraggableNode

struct DraggableNode<Item: MovableObject>: View {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    let nodeType: NodePosition
    let aspectRatio: CGFloat
    var item: Item

    var resizeCallback: (Item, CGSize) -> CGSize = { _, x in x }

    var body: some View {
        Image(systemName: "arrow.up.left.and.arrow.down.right")
            .iconStyle()
            .offset(x: kOffset, y: kOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        var newWidth = width
                        var newHeight = height

                        switch nodeType {
                        case .topLeft:
                            newWidth = width - value.translation.width
                            newHeight = newWidth / aspectRatio
                        case .topRight:
                            newWidth = width + value.translation.width
                            newHeight = newWidth / aspectRatio
                        case .bottomLeft:
                            newHeight = height + value.translation.height
                            newWidth = newHeight * aspectRatio
                        case .bottomRight:
                            newWidth = width + value.translation.width
                            newHeight = newWidth / aspectRatio
                        case .top:
                            newHeight = height - value.translation.height
                        case .bottom:
                            newHeight = height + value.translation.height
                        case .left:
                            newWidth = width - value.translation.width
                        case .right:
                            newWidth = width + value.translation.width
                        }

                        let newSize = resizeCallback(item, .init(width: newWidth, height: newHeight))

                        width = newSize.width
                        height = newSize.height
                    }
            )
    }
}

// MARK: - DraggableModifier

struct DraggableModifier<Item: MovableObject>: ViewModifier {
    // MARK: Lifecycle

    init(width: Binding<CGFloat>, height: Binding<CGFloat>, hasBorder _: Bool, item: Item, onResize: @escaping (Item, CGSize) -> CGSize) {
        aspectRatio = width.wrappedValue / height.wrappedValue
        _width = width
        _height = height
        self.onResize = onResize
        self.item = item
    }

    // MARK: Internal

    @Binding var width: CGFloat
    @Binding var height: CGFloat
    // 宽高比
    let aspectRatio: CGFloat
//    let hasBorder: Bool
    let onResize: (Item, CGSize) -> CGSize
    var item: Item

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                DraggableNode(
                    width: $width,
                    height: $height,
                    nodeType: .bottomRight,
                    aspectRatio: aspectRatio,
                    item: item,
                    resizeCallback: onResize
                )
            }
    }
}
