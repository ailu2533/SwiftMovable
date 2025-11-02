import Foundation
import SwiftUI

// MARK: - EdgeDragArea

// MARK: - MultiDirectionResizableModifier

public struct MultiDirectionResizableModifier<Item: MovableObject>: ViewModifier {
    // MARK: Lifecycle

    public init(
        width: Binding<CGFloat>,
        height: Binding<CGFloat>,
        hasBorder _: Bool,
        item: Item,
        onResize: @escaping (Item, CGSize) -> CGSize,
        showDragIndicators: Bool = false
    ) {
        aspectRatio = width.wrappedValue / height.wrappedValue
        _width = width
        _height = height
        self.onResize = onResize
        self.item = item
        self.isSelected = showDragIndicators
    }

    // MARK: Internal

    @State private var pinchMagnification: CGFloat = 1

    @Binding var width: CGFloat
    @Binding var height: CGFloat
    // 宽高比
    let aspectRatio: CGFloat
    let onResize: (Item, CGSize) -> CGSize
    var item: Item
    var isSelected: Bool

    public func body(content: Content) -> some View {
        content
            .frame(width: width * pinchMagnification, height: height * pinchMagnification)
            // Top edge
            .overlay(alignment: .top) {
                TopEdgeDragArea(
                    width: $width,
                    height: $height,
                    item: item,
                    resizeCallback: onResize,
                    showVisualIndicator: isSelected
                )
            }
            // Left edge
            .overlay(alignment: .leading) {
                LeftEdgeDragArea(
                    width: $width,
                    height: $height,
                    item: item,
                    resizeCallback: onResize,
                    showVisualIndicator: isSelected
                )
            }
            // Right edge
            .overlay(alignment: .trailing) {
                RightEdgeDragArea(
                    width: $width,
                    height: $height,
                    item: item,
                    resizeCallback: onResize,
                    showVisualIndicator: isSelected
                )
            }
            // Bottom edge
            .overlay(alignment: .bottom) {
                BottomEdgeDragArea(
                    width: $width,
                    height: $height,
                    item: item,
                    resizeCallback: onResize,
                    showVisualIndicator: isSelected
                )
            }
    }
}
