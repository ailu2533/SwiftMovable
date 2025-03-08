//
//  MovableObjectView.swift
//
//
//  Created by ailu on 2024/4/27.
//

import SwiftUI

// MARK: - MovableObjectView

public struct MovableObjectView<Item: MovableObject, Content: View>: View {
    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        item: Item,
        selection: Binding<MovableObject?>,
        config: MovableObjectViewConfig<Item>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.item = item
        self.config = config
        self.content = content
        _selection = selection
    }

    // MARK: Public

    public var body: some View {
        content(item)
            .zIndex(item.zIndex)
            .modifier(MovableViewModifier(
                currentRotation: currentRotationAngle,
                position: $item.pos,
                height: $item.height,
                width: $item.width,
                isSelected: selected,
                config: config,
                item: item
            ))
            .disabled(!selected)
            .onTapGesture {
                selection = item
                item.zIndex = Date().timeIntervalSince1970
                config.onTap(item)
            }
    }

    // MARK: Internal

    @Bindable var item: Item
    @Binding var selection: MovableObject?
    var config: MovableObjectViewConfig<Item>
    @ViewBuilder var content: (Item) -> Content

    // MARK: Private

    private var selected: Bool { selection == item }
    private var showControl: Bool { selected && config.isEnabled }
    private var currentRotationAngle: Binding<Angle> {
        Binding(
            get: { Angle(degrees: item.rotationDegree) },
            set: { item.rotationDegree = $0.degrees }
        )
    }
}
