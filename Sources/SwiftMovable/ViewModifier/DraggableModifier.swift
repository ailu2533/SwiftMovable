//
//  File.swift
//
//
//  Created by ailu on 2024/7/3.
//

import Foundation

import SwiftUI

enum NodePosition {
    case topLeft, topRight, bottomLeft, bottomRight
}

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
            .offset(x: Offset, y: Offset)

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
                        }

                        let newSize = resizeCallback(item, .init(width: newWidth, height: newHeight))

                        width = newSize.width
                        height = newSize.height
                    }
            )
    }
}

struct DraggableModifier<Item: MovableObject>: ViewModifier {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    // 宽高比
    let aspectRatio: CGFloat
//    let hasBorder: Bool
    let onResize: (Item, CGSize) -> CGSize
    var item: Item

    init(width: Binding<CGFloat>, height: Binding<CGFloat>, hasBorder: Bool, item: Item, onResize: @escaping (Item, CGSize) -> CGSize) {
        aspectRatio = width.wrappedValue / height.wrappedValue
        _width = width
        _height = height
        self.onResize = onResize
        self.item = item
    }

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                DraggableNode(width: $width, height: $height, nodeType: .bottomRight, aspectRatio: aspectRatio, item: item, resizeCallback: onResize)
            }
    }
}
