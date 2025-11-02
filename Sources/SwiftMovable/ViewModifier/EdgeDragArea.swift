//
//  EdgeDragArea.swift
//  SwiftMovable
//
//  Created by Lu Ai on 2025/11/1.
//

import Foundation
import SwiftUI

// MARK: - EdgeResizeGesture

private let dragAreaSize: CGFloat = 10
private let borderHalfWidth: CGFloat = 12
// private let dragOffset = dragAreaSize / 2 - borderHalfWidth
private let dragOffset = dragAreaSize / 2 - 1

public enum EdgeType {
    case top, bottom, left, right
}

/// 边缘调整大小手势的封装
struct EdgeResizeGesture<Item: MovableObject> {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    let edgeType: EdgeType
    var item: Item
    var resizeCallback: (Item, CGSize) -> CGSize

    /// 创建并返回配置好的拖拽手势
    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // 保存原始尺寸
                let oldWidth = width
                let oldHeight = height

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

                // 计算尺寸变化
                let deltaWidth = newSize.width - oldWidth
                let deltaHeight = newSize.height - oldHeight

                // 根据边缘类型调整位置，使对面边缘保持固定
                switch edgeType {
                case .top:
                    // 顶部边缘拖拽时，保持底部边缘固定
                    // 中心点需要向上移动 deltaHeight/2
                    item.pos.y -= deltaHeight / 2
                case .bottom:
                    // 底部边缘拖拽时，保持顶部边缘固定
                    // 中心点需要向下移动 deltaHeight/2
                    item.pos.y += deltaHeight / 2
                case .left:
                    // 左边缘拖拽时，保持右边缘固定
                    // 中心点需要向左移动 deltaWidth/2
                    item.pos.x -= deltaWidth / 2
                case .right:
                    // 右边缘拖拽时，保持左边缘固定
                    // 中心点需要向右移动 deltaWidth/2
                    item.pos.x += deltaWidth / 2
                }

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

    var body: some View {
        Capsule()
            .fill(showVisualIndicator ? Color(.lightPink) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxWidth: min(width * 0.5, 100), maxHeight: dragAreaSize)
            .offset(y: -dragOffset)
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

    var body: some View {
        Capsule()
            .fill(showVisualIndicator ? Color(.lightPink) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxWidth: min(width * 0.5, 100), maxHeight: dragAreaSize)
            .offset(y: dragOffset)
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

    var body: some View {
        Capsule()
            .fill(showVisualIndicator ? Color(.lightPink) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxWidth: dragAreaSize, maxHeight: min(height * 0.5, 100))
            .offset(x: -dragOffset)
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

    var body: some View {
        Capsule()
            .fill(showVisualIndicator ? Color(.lightPink) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxWidth: dragAreaSize, maxHeight: min(height * 0.5, 100))
            .offset(x: dragOffset)
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
