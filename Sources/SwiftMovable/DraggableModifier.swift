//
//  File.swift
//
//
//  Created by ailu on 2024/7/3.
//

import Foundation

import SwiftUI

enum nodePosition {
    case TopLeft, TopRight,

         BottomLeft, BottomRight
}

struct DraggableNode: View {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    let nodeType: nodePosition
    let aspectRatio: CGFloat

    var body: some View {
        Image(systemName: "arrow.up.left.and.arrow.down.right")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 12, height: 12)

            .padding(5)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 1)
            .offset(x: 40, y: 40)

            .gesture(
                DragGesture()
                    .onChanged { value in
                        var newWidth = width
                        var newHeight = height

                        switch nodeType {
                        case .TopLeft:
                            newWidth = width - value.translation.width
                            newHeight = newWidth / aspectRatio
                        case .TopRight:
                            newWidth = width + value.translation.width
                            newHeight = newWidth / aspectRatio
                        case .BottomLeft:
                            newHeight = height + value.translation.height
                            newWidth = newHeight * aspectRatio
                        case .BottomRight:
                            newHeight = height + value.translation.height
                            newWidth = newHeight * aspectRatio
                        }

                        // 确保最短的边至少为10，并避免除以零的情况
                        let minDimension = max(1, min(newWidth, newHeight)) // 使用1作为最小值，避免除以零
                        if minDimension < 10 {
                            let scale = 10 / minDimension
                            newWidth = max(10, newWidth * scale)
                            newHeight = max(10, newHeight * scale)
                        }

                        // 额外的安全检查
                        width = max(10, newWidth)
                        height = max(10, newHeight)
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
                DraggableNode(width: $width, height: $height, nodeType: .BottomRight, aspectRatio: aspectRatio)
            }
    }
}
