import Foundation
import SwiftUI

// MARK: - EdgeDragArea

// MARK: - MultiDirectionResizableModifier

public struct MultiDirectionResizableModifier<Item: MovableObject>: ViewModifier {
    // MARK: Lifecycle

    public init(
        hasBorder _: Bool,
        item: Item,
        onResize: @escaping (Item, CGSize) -> CGSize,
        showDragIndicators: Bool = false,
        onEdgeDrag: EdgeDragCallback<Item>? = nil
    ) {
        self.onResize = onResize
        self.item = item
        isSelected = showDragIndicators
        self.onEdgeDrag = onEdgeDrag
    }

    // MARK: Internal

    @State private var pinchMagnification: CGFloat = 1

    let onResize: (Item, CGSize) -> CGSize
    var item: Item
    var isSelected: Bool
    var onEdgeDrag: EdgeDragCallback<Item>?

    public func body(content: Content) -> some View {
        content
            .frame(width: item.width * pinchMagnification, height: item.height * pinchMagnification)
            // Top edge
            .overlay(alignment: .top) {
                EdgeDragArea(
                    edgeType: .top,
                    item: item,
                    resizeCallback: onResize,
                    onEdgeDrag: onEdgeDrag,
                    showVisualIndicator: isSelected
                )
            }
            // Left edge
            .overlay(alignment: .leading) {
                EdgeDragArea(
                    edgeType: .left,
                    item: item,
                    resizeCallback: onResize,
                    onEdgeDrag: onEdgeDrag,
                    showVisualIndicator: isSelected
                )
            }
            // Right edge
            .overlay(alignment: .trailing) {
                EdgeDragArea(
                    edgeType: .right,
                    item: item,
                    resizeCallback: onResize,
                    onEdgeDrag: onEdgeDrag,
                    showVisualIndicator: isSelected
                )
            }
            // Bottom edge
            .overlay(alignment: .bottom) {
                EdgeDragArea(
                    edgeType: .bottom,
                    item: item,
                    resizeCallback: onResize,
                    onEdgeDrag: onEdgeDrag,
                    showVisualIndicator: isSelected
                )
            }
    }
}
