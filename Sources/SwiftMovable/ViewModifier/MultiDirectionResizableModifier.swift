import Foundation
import SwiftUI

// MARK: - EdgeDragArea

// MARK: - MultiDirectionResizableModifier

public struct MultiDirectionResizableModifier<Item: MovableObject>: ViewModifier {
    // MARK: Lifecycle

    public init(
        item: Item,
        showDragIndicators: Bool = false,
        onEdgeDrag: EdgeDragCallback<Item>? = nil
    ) {
        self.item = item
        isSelected = showDragIndicators
        self.onEdgeDrag = onEdgeDrag
    }

    // MARK: Internal

    var item: Item
    let isSelected: Bool
    var onEdgeDrag: EdgeDragCallback<Item>?

    public func body(content: Content) -> some View {
        content
            .frame(width: item.width, height: item.height)
            .overlay {
                Color.clear
                    .border(Color(.lightPink), width: 2)
                    .opacity(isSelected ? 1 : 0)

                EdgeDragArea(
                    edgeType: .top,
                    item: item,
                    onEdgeDrag: onEdgeDrag,
                )
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(isSelected ? 1 : 0)

                EdgeDragArea(
                    edgeType: .left,
                    item: item,
                    onEdgeDrag: onEdgeDrag,
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(isSelected ? 1 : 0)

                EdgeDragArea(
                    edgeType: .right,
                    item: item,
                    onEdgeDrag: onEdgeDrag,
                )
                .frame(maxWidth: .infinity, alignment: .trailing)
                .opacity(isSelected ? 1 : 0)

                EdgeDragArea(
                    edgeType: .bottom,
                    item: item,
                    onEdgeDrag: onEdgeDrag,
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .opacity(isSelected ? 1 : 0)
            }
            .position(item.pos)
            .zIndex(item.zIndex)
    }
}
