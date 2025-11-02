//
//  MovableObject+EdgeResize.swift
//  SwiftMovable
//
//  Created by Lu Ai on 2025/11/2.
//

import Foundation
import SwiftUI

@available(macOS 14.0, *)
extension MovableObject {
    /// 移动指定边缘并调整对象的尺寸和位置
    ///
    /// 此方法封装了边缘调整大小的完整逻辑：
    /// 1. 根据边缘类型和平移量计算新尺寸
    /// 2. 应用尺寸约束回调
    /// 3. 调整位置以保持对面边缘固定
    /// 4. 更新对象的宽度和高度
    ///
    /// - Parameters:
    ///   - edgeType: 被拖拽的边缘类型 (.top, .bottom, .left, .right)
    ///   - translation: 拖拽的平移量
    ///   - constrainedBy: 可选的尺寸约束回调，用于限制最终尺寸
    public func moveEdge(
        _ edgeType: EdgeType,
        by translation: CGSize,
        constrainedBy callback: ((MovableObject, CGSize) -> CGSize)? = nil
    ) {
        // 保存原始尺寸
        let oldWidth = width
        let oldHeight = height
        
        var newWidth = width
        var newHeight = height
        
        // 根据边缘类型计算新尺寸
        switch edgeType {
        case .top:
            newHeight = height - translation.height
        case .bottom:
            newHeight = height + translation.height
        case .left:
            newWidth = width - translation.width
        case .right:
            newWidth = width + translation.width
        }
        
        // 应用尺寸约束回调（如果提供）
        let constrainedSize: CGSize
        if let callback = callback {
            constrainedSize = callback(self, CGSize(width: newWidth, height: newHeight))
        } else {
            constrainedSize = CGSize(width: newWidth, height: newHeight)
        }
        
        // 计算尺寸变化
        let deltaWidth = constrainedSize.width - oldWidth
        let deltaHeight = constrainedSize.height - oldHeight
        
        // 根据边缘类型调整位置，使对面边缘保持固定
        switch edgeType {
        case .top:
            // 顶部边缘拖拽时，保持底部边缘固定
            // 中心点需要向上移动 deltaHeight/2
            pos.y -= deltaHeight / 2
        case .bottom:
            // 底部边缘拖拽时，保持顶部边缘固定
            // 中心点需要向下移动 deltaHeight/2
            pos.y += deltaHeight / 2
        case .left:
            // 左边缘拖拽时，保持右边缘固定
            // 中心点需要向左移动 deltaWidth/2
            pos.x -= deltaWidth / 2
        case .right:
            // 右边缘拖拽时，保持左边缘固定
            // 中心点需要向右移动 deltaWidth/2
            pos.x += deltaWidth / 2
        }
        
        // 更新对象的尺寸
        width = constrainedSize.width
        height = constrainedSize.height
    }
}

