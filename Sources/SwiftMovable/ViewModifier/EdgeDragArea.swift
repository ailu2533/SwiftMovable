//
//  EdgeDragArea.swift
//  SwiftMovable
//
//  Created by Lu Ai on 2025/11/1.
//

import Foundation
import SwiftUI

// MARK: - EdgeResizeGesture

/// 边缘调整大小手势的封装
struct EdgeResizeGesture<Item: MovableObject> {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    let edgeType: EdgeType
    var item: Item
    var resizeCallback: (Item, CGSize) -> CGSize

    enum EdgeType {
        case top, bottom, left, right
    }

    /// 创建并返回配置好的拖拽手势
    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                var newWidth = width
                var newHeight = height

                switch edgeType {
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
    }
}

// MARK: - Top Edge

struct TopEdgeDragArea<Item: MovableObject>: View {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    var item: Item
    var resizeCallback: (Item, CGSize) -> CGSize = { _, x in x }
    var showVisualIndicator: Bool = false

    private let dragAreaSize: CGFloat = 16

    var body: some View {
        Rectangle()
            .fill(showVisualIndicator ? Color.blue.opacity(0.2) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxHeight: dragAreaSize)
            .gesture(
                EdgeResizeGesture(
                    width: $width,
                    height: $height,
                    edgeType: .top,
                    item: item,
                    resizeCallback: resizeCallback
                ).gesture
            )
    }
}

// MARK: - Bottom Edge

struct BottomEdgeDragArea<Item: MovableObject>: View {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    var item: Item
    var resizeCallback: (Item, CGSize) -> CGSize = { _, x in x }
    var showVisualIndicator: Bool = false

    private let dragAreaSize: CGFloat = 16

    var body: some View {
        Rectangle()
            .fill(showVisualIndicator ? Color.blue.opacity(0.2) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxHeight: dragAreaSize)
            .gesture(
                EdgeResizeGesture(
                    width: $width,
                    height: $height,
                    edgeType: .bottom,
                    item: item,
                    resizeCallback: resizeCallback
                ).gesture
            )
    }
}

// MARK: - Left Edge

struct LeftEdgeDragArea<Item: MovableObject>: View {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    var item: Item
    var resizeCallback: (Item, CGSize) -> CGSize = { _, x in x }
    var showVisualIndicator: Bool = false

    private let dragAreaSize: CGFloat = 16

    var body: some View {
        Rectangle()
            .fill(showVisualIndicator ? Color.blue.opacity(0.2) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxWidth: dragAreaSize)
            .gesture(
                EdgeResizeGesture(
                    width: $width,
                    height: $height,
                    edgeType: .left,
                    item: item,
                    resizeCallback: resizeCallback
                ).gesture
            )
    }
}

// MARK: - Right Edge

struct RightEdgeDragArea<Item: MovableObject>: View {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    var item: Item
    var resizeCallback: (Item, CGSize) -> CGSize = { _, x in x }
    var showVisualIndicator: Bool = false

    private let dragAreaSize: CGFloat = 16

    var body: some View {
        Rectangle()
            .fill(showVisualIndicator ? Color.blue.opacity(0.2) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxWidth: dragAreaSize)
            .gesture(
                EdgeResizeGesture(
                    width: $width,
                    height: $height,
                    edgeType: .right,
                    item: item,
                    resizeCallback: resizeCallback
                ).gesture
            )
    }
}
