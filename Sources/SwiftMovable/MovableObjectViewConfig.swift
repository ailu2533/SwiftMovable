//
//  File.swift
//
//
//  Created by ailu on 2024/7/12.
//

import Foundation

public struct MovableObjectViewConfig<Item: MovableObject> {
    public typealias MovableObjectCallback = (Item) -> Void
    public typealias ResizeCallback = (Item, CGSize) -> CGSize

    public let parentSize: CGSize?
    public let isEnabled: Bool
    public let onDelete: MovableObjectCallback
    public let onEdit: MovableObjectCallback
    public let onTap: MovableObjectCallback
    public let onResize: ResizeCallback

    // 是否可以放缩
    public let isResizable: Bool

    private init(builder: Builder) {
        parentSize = builder.parentSize
        isEnabled = builder.isEnabled
        onDelete = builder.onDelete
        onEdit = builder.onEdit
        onTap = builder.onTap
        isResizable = builder.isResizable
        onResize = builder.onResize
    }

    public class Builder {
        var parentSize: CGSize?
        var isEnabled: Bool = true
        var onDelete: MovableObjectCallback = { _ in }
        var onEdit: MovableObjectCallback = { _ in }
        var onTap: MovableObjectCallback = { _ in }
        var isResizable: Bool = false
        var onResize: ResizeCallback = { _,proposedSize in proposedSize }
//        var onResize2: ResizeCallback2 = { _, proposedSize in proposedSize }

        public init() {}

        public func setParentSize(_ size: CGSize?) -> Builder {
            parentSize = size
            return self
        }

        public func setIsEnabled(_ enabled: Bool) -> Builder {
            isEnabled = enabled
            return self
        }

        public func setOnDelete(_ callback: @escaping MovableObjectCallback) -> Builder {
            onDelete = callback
            return self
        }

        public func setOnEdit(_ callback: @escaping MovableObjectCallback) -> Builder {
            onEdit = callback
            return self
        }

        public func setOnTap(_ callback: @escaping MovableObjectCallback) -> Builder {
            onTap = callback
            return self
        }

        public func setIsResizable(_ resizable: Bool) -> Builder {
            isResizable = resizable
            return self
        }

        public func setOnResize(_ callback: @escaping ResizeCallback) -> Builder {
            onResize = callback
            return self
        }

        public func build() -> MovableObjectViewConfig<Item> {
            return MovableObjectViewConfig<Item>(builder: self)
        }
    }
}
