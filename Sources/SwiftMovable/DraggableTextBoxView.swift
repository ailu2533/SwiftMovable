//
//  DraggableTextBoxView.swift
//  SwiftMovable
//
//  Created by Lu Ai on 2025/11/19.
//

import SwiftUI

// MARK: - TextBoxObject

/// A movable object that contains text with dynamic font sizing
@available(macOS 14.0, *)
@Observable
public class TextBoxObject: MovableObject {
    // MARK: Lifecycle

    public init(
        id: UUID = UUID(),
        pos: CGPoint,
        width: CGFloat = 200,
        height: CGFloat = 100,
        text: String = "hello, \n世界\n这是一个测试"
    ) {
        self.text = text
        super.init(id: id, pos: pos, width: width, height: height)
        // Calculate initial font size (不允许自动换行)
        fontSize = text.calculateFontSize(
            availableSize: CGSize(width: width, height: height),
            allowsWrapping: false
        )
    }

    // MARK: Public

    public let text: String
    public var fontSize: CGFloat = 16
}

// MARK: - DraggableTextBoxView

/// A view that displays a draggable and resizable text box with dynamic font sizing
@available(macOS 14.0, *)
public struct DraggableTextBoxView: View {
    // MARK: Lifecycle

    public init() {
        let textBox = TextBoxObject(
            pos: CGPoint(x: 200, y: 200),
            width: 200,
            height: 100
        )
        self.textBox = textBox
        _selection = State(initialValue: textBox)
    }

    // MARK: Public

    public var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()

            MovableObjectView(
                item: textBox,
                selection: $selection,
                config: config
            ) { item in
                Text(item.text)
                    .font(.system(size: item.fontSize))
                    .fixedSize()
            }
        }
        .coordinateSpace(name: "canvas")
        .environment(\.canvasCoordinateSpace, "canvas")
    }

    // MARK: Private

    @State private var textBox: TextBoxObject
    @State private var selection: MovableObject?

    private var config: MovableObjectViewConfig<TextBoxObject> {
        MovableObjectViewConfig.Builder()
            .setIsResizable(true)
            .setOnResize { item, proposedSize in
                // Calculate the optimal font size for the new size
                // allowsWrapping: false 表示只在显式 \n 处换行，不自动换行
                let newFontSize = item.text.calculateFontSize(
                    availableSize: proposedSize,
                    maxFontSize: 50,
                    minFontSize: 1,
                    allowsWrapping: false
                )

                // Update the item's font size
                item.fontSize = newFontSize

                // Return the proposed size
                return proposedSize
            }
            .setOnDelete { item in
                print("Delete tapped for item: \(item.id)")
            }
            .setOnTap { item in
                print("Tapped on text box: \(item.text)")
            }
            .build()
    }
}

// MARK: - Preview

#Preview {
    DraggableTextBoxView()
}
