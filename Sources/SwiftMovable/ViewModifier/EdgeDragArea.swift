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

/// 边缘拖拽回调类型
/// 参数：
/// - item: 被拖拽的对象
/// - edgeType: 被拖拽的边缘类型
/// - translation: 拖拽的平移量
/// - oldSize: 调整前的尺寸
/// - newSize: 调整后的尺寸
public typealias EdgeDragCallback<Item: MovableObject> = (Item, EdgeType, CGSize, CGSize, CGSize) -> Void

// MARK: - Unified Edge Drag Area

/// 统一的边缘拖拽区域视图
/// 通过 edgeType 参数区分四种边缘类型
struct EdgeDragArea<Item: MovableObject>: View {
    let edgeType: EdgeType
    var item: Item
    var resizeCallback: (Item, CGSize) -> CGSize = { _, x in x }
    var onEdgeDrag: EdgeDragCallback<Item>? = nil
    var showVisualIndicator: Bool = false

    // MARK: - Computed Properties

    /// 根据边缘类型计算最大宽度
    private var maxWidth: CGFloat {
        switch edgeType {
        case .top, .bottom:
            return min(item.width * 0.5, 100)
        case .left, .right:
            return dragAreaSize
        }
    }

    /// 根据边缘类型计算最大高度
    private var maxHeight: CGFloat {
        switch edgeType {
        case .top, .bottom:
            return dragAreaSize
        case .left, .right:
            return min(item.height * 0.5, 100)
        }
    }

    /// 根据边缘类型计算 X 轴偏移
    private var offsetX: CGFloat {
        switch edgeType {
        case .top, .bottom:
            return 0
        case .left:
            return -dragOffset
        case .right:
            return dragOffset
        }
    }

    /// 根据边缘类型计算 Y 轴偏移
    private var offsetY: CGFloat {
        switch edgeType {
        case .top:
            return -dragOffset
        case .bottom:
            return dragOffset
        case .left, .right:
            return 0
        }
    }

    // MARK: - Body

    var body: some View {
        Capsule()
            .fill(showVisualIndicator ? Color(.lightPink) : Color.clear)
            .contentShape(Rectangle())
            .frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .offset(x: offsetX, y: offsetY)
            .modifier(
                EdgeResizeGesture(
                    edgeType: edgeType,
                    item: item,
                    resizeCallback: resizeCallback,
                    onEdgeDrag: onEdgeDrag
                )
            )
    }
}
