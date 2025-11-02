//
//  EdgeResizeGesture.swift
//  SwiftMovable
//
//  Created by Lu Ai on 2025/11/2.
//

import Foundation
import SwiftUI

/// 边缘调整大小手势的 ViewModifier
struct EdgeResizeGesture<Item: MovableObject>: ViewModifier {
    let edgeType: EdgeType
    var item: Item
    var onEdgeDrag: EdgeDragCallback<Item>?

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // 使用 MovableObject 的边缘移动方法
                        // 创建一个适配器闭包来处理泛型类型转换
                        item.moveEdge(edgeType, by: value.translation)
                        // 调用边缘拖拽回调，通知其他对象
                        onEdgeDrag?(item, edgeType, value.translation)
                    }
            )
    }
}
