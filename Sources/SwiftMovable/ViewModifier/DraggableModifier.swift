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

struct DraggableNode: View {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    let nodeType: NodePosition
    let aspectRatio: CGFloat

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
                            newHeight = height + value.translation.height
                            newWidth = newHeight * aspectRatio
                        }

                        // 确保最短的边至少为10，并避免除以零的情况
                        let minDimension = max(1, min(newWidth, newHeight)) // 使用1作为最小值，避免除以零
                        if minDimension < 40 {
                            let scale = 40 / minDimension
                            newWidth = max(40, newWidth * scale)
                            newHeight = max(40, newHeight * scale)
                        }

                        // 额外的安全检查
                        width = max(40, newWidth)
                        height = max(40, newHeight)
                    }
            )
    }
}

struct DraggableModifier: ViewModifier {
    @Binding var width: CGFloat
    @Binding var height: CGFloat

    @State private var aspectRatio: CGFloat = 1.0

    let hasBorder: Bool

    func body(content: Content) -> some View {
        content
            .readSize(callback: { size in
                aspectRatio = size.width / size.height
            })
            .overlay(alignment: .bottomTrailing) {
                DraggableNode(width: $width, height: $height, nodeType: .bottomRight, aspectRatio: aspectRatio)
            }
    }
}
