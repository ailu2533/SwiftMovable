//
//  File.swift
//
//
//  Created by ailu on 2024/7/12.
//

import Foundation

public struct MovableObjectViewConfig {
    public typealias MovableObjectCallback = (MovableObject) -> Void

    public let parentSize: CGSize?
    public let isEnabled: Bool
    public let onDelete: MovableObjectCallback
    public let onEdit: MovableObjectCallback
    public let onTap: MovableObjectCallback

    // 是否可以放缩
    public let isResizable: Bool

    private init(builder: Builder) {
        parentSize = builder.parentSize
        isEnabled = builder.isEnabled
        onDelete = builder.onDelete
        onEdit = builder.onEdit
        onTap = builder.onTap
        isResizable = builder.isResizable
    }

    public class Builder {
        var parentSize: CGSize?
        var isEnabled: Bool = true
        var onDelete: MovableObjectCallback = { _ in }
        var onEdit: MovableObjectCallback = { _ in }
        var onTap: MovableObjectCallback = { _ in }
        var isResizable: Bool = false
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

        public func build() -> MovableObjectViewConfig {
            return MovableObjectViewConfig(builder: self)
        }
    }
}
