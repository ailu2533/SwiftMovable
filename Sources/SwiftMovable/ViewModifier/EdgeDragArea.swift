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
// private let dragOffset = dragAreaSize / 2 - borderHalfWidth
private let dragOffset = dragAreaSize / 2 - 1

public enum EdgeType: Int, CaseIterable, Identifiable {
    case top, bottom, left, right

    var alignment: Alignment {
        switch self {
        case .top:
            .top
        case .bottom:
            .bottom
        case .left:
            .leading
        case .right:
            .trailing
        }
    }

    public var id: Int {
        rawValue
    }
}

/// 边缘拖拽回调类型
/// 参数：
/// - item: 被拖拽的对象
/// - edgeType: 被拖拽的边缘类型
/// - translation: 拖拽的平移量
public typealias EdgeDragCallback<Item: MovableObject> = (Item, EdgeType, CGSize) -> Void

/// 统一的边缘拖拽区域视图
/// 通过 edgeType 参数区分四种边缘类型
struct EdgeDragArea<Item: MovableObject>: View {
    let edgeType: EdgeType
    var item: Item
    var onEdgeDrag: EdgeDragCallback<Item>?

    // MARK: - Computed Properties

    /// 根据边缘类型计算最大宽度
    private var maxWidth: CGFloat {
        switch edgeType {
        case .top, .bottom:
            min(item.width * 0.5, 100)
        case .left, .right:
            dragAreaSize
        }
    }

    /// 根据边缘类型计算最大高度
    private var maxHeight: CGFloat {
        switch edgeType {
        case .top, .bottom:
            dragAreaSize
        case .left, .right:
            min(item.height * 0.5, 100)
        }
    }

    // MARK: - Body

    var body: some View {
        Capsule()
            .fill(Color(.lightPink))
            .contentShape(Rectangle())
            .frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .offset(x: edgeType.offsetX, y: edgeType.offsetY)
            .modifier(
                EdgeResizeGesture(
                    edgeType: edgeType,
                    item: item,
                    onEdgeDrag: onEdgeDrag
                )
            )
    }
}

private extension EdgeType {
    /// 根据边缘类型计算 X 轴偏移
    var offsetX: CGFloat {
        switch self {
        case .top, .bottom:
            0
        case .left:
            -dragOffset
        case .right:
            dragOffset
        }
    }

    /// 根据边缘类型计算 Y 轴偏移
    var offsetY: CGFloat {
        switch self {
        case .top:
            -dragOffset
        case .bottom:
            dragOffset
        case .left, .right:
            0
        }
    }
}
