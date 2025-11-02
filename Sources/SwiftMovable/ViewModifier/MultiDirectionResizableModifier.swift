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
                if isSelected {
                    Color.clear
                        .border(Color(.lightPink), width: 2)
                        .opacity(isSelected ? 1 : 0)

                    ForEach(EdgeType.allCases) { edgeType in
                        EdgeDragArea(
                            edgeType: edgeType,
                            item: item,
                            onEdgeDrag: onEdgeDrag,
                        )
                        .frame(maxWidth: edgeType.maxWidth, maxHeight: edgeType.maxHeight, alignment: edgeType.alignment)
                    }
                }
            }
            .position(item.pos)
            .zIndex(item.zIndex)
    }
}

extension EdgeType {
    var maxHeight: CGFloat? {
        switch self {
        case .top:
            .infinity
        case .bottom:
            .infinity
        case .left:
            nil
        case .right:
            nil
        }
    }

    var maxWidth: CGFloat? {
        switch self {
        case .top:
            nil
        case .bottom:
            nil
        case .left:
            .infinity
        case .right:
            .infinity
        }
    }
}
