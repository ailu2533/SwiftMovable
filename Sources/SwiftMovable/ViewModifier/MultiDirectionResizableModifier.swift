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
            .overlay(alignment: .top) {
                EdgeDragArea(
                    edgeType: .top,
                    item: item,
                    onEdgeDrag: onEdgeDrag,
                    showVisualIndicator: isSelected
                )
            }
            .overlay(alignment: .leading) {
                EdgeDragArea(
                    edgeType: .left,
                    item: item,
                    onEdgeDrag: onEdgeDrag,
                    showVisualIndicator: isSelected
                )
            }
            .overlay(alignment: .trailing) {
                EdgeDragArea(
                    edgeType: .right,
                    item: item,
                    onEdgeDrag: onEdgeDrag,
                    showVisualIndicator: isSelected
                )
            }
            .overlay(alignment: .bottom) {
                EdgeDragArea(
                    edgeType: .bottom,
                    item: item,
                    onEdgeDrag: onEdgeDrag,
                    showVisualIndicator: isSelected
                )
            }
    }
}
