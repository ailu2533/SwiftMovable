//
//  MovableObject.swift
//
//
//  Created by ailu on 2024/4/27.
//

import Foundation
import SwiftUI

@available(macOS 14.0, *)
@Observable
open class MovableObject: MovableObjectProtocol, Equatable {
    // MARK: Lifecycle

    public init(
        id: UUID = UUID(),
        pos: CGPoint,
        rotationDegree: CGFloat = .zero,
        width: CGFloat = 50,
        height: CGFloat = 50
    ) {
        self.id = id
        self.pos = pos
        self.rotationDegree = rotationDegree
        self.width = width
        self.height = height
        zIndex = Date().timeIntervalSince1970
    }

    // MARK: Open

    open func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(pos.x)
        hasher.combine(pos.y)
        hasher.combine(rotationDegree)
        hasher.combine(zIndex)
        hasher.combine(width)
        hasher.combine(height)
    }

    // MARK: Public

    public let id: UUID
    public var offset: CGPoint = .zero
    public var pos: CGPoint = .zero
    public var rotationDegree: CGFloat = .zero
    public var zIndex: Double = 1.0
    public var width: CGFloat = 0
    public var height: CGFloat = 0

    public static func == (lhs: MovableObject, rhs: MovableObject) -> Bool {
        lhs.id == rhs.id
            && lhs.pos == rhs.pos
            && lhs.rotationDegree == rhs.rotationDegree
            && lhs.zIndex == rhs.zIndex
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }

    public func onDragChanged(translation: CGSize) {
        offset = .init(x: translation.width, y: translation.height)
    }

    public func onDragEnd() {
        pos = .init(x: pos.x + offset.x, y: pos.y + offset.y)
        offset = .zero
    }
}

public extension MovableObject {
    var size: CGSize {
        CGSize(width: width, height: height)
    }
}
