//
//  File.swift
//
//
//  Created by ailu on 2024/7/13.
//

import Foundation
import SwiftUI

struct MovableModifier: ViewModifier {
    @State var positionX: CGFloat = 100
    @State var positionY: CGFloat = 100
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0

    var parentSize: CGSize?

    private func onDragChanged(translation: CGSize) {
        offsetX = translation.width
        offsetY = translation.height
    }

    private func onDragEnd() {
        positionX += offsetX
        positionY += offsetY

        offsetX = .zero
        offsetY = .zero
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let locationX = value.location.x
                let locationY = value.location.y
                if let parentSize {
                    if locationX < 0 || locationY < 0 || locationX > parentSize.width || locationY > parentSize.height {
                        return
                    }
                }
                onDragChanged(translation: value.translation)
            }
            .onEnded { _ in
                onDragEnd()
            }
    }

    func body(content: Content) -> some View {
        return content
            .position(x: positionX, y: positionY)
            .offset(x: offsetX, y: offsetY)
            .gesture(dragGesture)
    }
}
