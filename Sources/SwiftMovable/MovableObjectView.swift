//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/27.
//

import SwiftUI

public struct MovableObjectView<Item: MovableObject, Content: View>: View {
    // MARK: - Properties

    @Bindable var item: Item
    @Binding var selection: MovableObject?
    private var config: MovableObjectViewConfig<Item>
    var content: (Item) -> Content

    var selected: Bool { selection == item }
    var showControl: Bool { selected && config.isEnabled }

    // MARK: - Initializer

    public init(item: Item, selection: Binding<MovableObject?>, config: MovableObjectViewConfig<Item>, @ViewBuilder content: @escaping (Item) -> Content) {
        self.item = item
        self.config = config
        self.content = content
        _selection = selection
    }

    // MARK: - Body

    public var body: some View {
        content(item)
            .modifier(MovableViewModifier(
                currentRotation:
                Binding(get: {
                    Angle(degrees: item.rotationDegree)
                }, set: { value in
                    item.rotationDegree = value.degrees
                }),
                position: $item.pos,
                height: $item.height,
                width: $item.width,
                isSelected: selected,
                config: config,
                item: item
            ))

            .onTapGesture {
                config.onTap(item)
                selection = item
            }
    }
}

public class MovableImage: MovableObject {
    public var imageName: String = "plus"
}

// #Preview("3") {
//    MovablePreview()
// }
//
// public struct MovablePreview: View {
//    public init() {}
//
//    @State private var selected: UUID?
//
//    @State private var item = MovableImage(pos: .init(x: 100, y: 100))
//
//    public var body: some View {
//        MovableObjectView(item: item, selection: $selected, config: MovableObjectViewConfig.Builder().build()) { item in
//            Image(systemName: item.imageName)
//                .resizable()
//                .scaledToFit()
//        }
//    }
// }
