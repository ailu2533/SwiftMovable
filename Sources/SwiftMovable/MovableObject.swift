//
//  File.swift
//
//
//  Created by ailu on 2024/4/27.
//

import Foundation
import SwiftUI

@available(macOS 14.0, *)
@Observable
open class MovableObject: MovableObjectProtocol, Equatable {
    @ObservationIgnored public var id: UUID
    public var offset: CGPoint = .zero
    public var pos: CGPoint = .zero
    public var rotationDegree: CGFloat = .zero
    public var zIndex: Double = 1.0
    public var width: CGFloat = 0
    public var height: CGFloat = 0

    enum CodingKeys: String, CodingKey {
        case id
        case posX
        case posY
        case rotationDegree
        case zIndex
        case width
        case height
    }

    public init(id: UUID = UUID(), pos: CGPoint, rotationDegree: CGFloat = .zero, width: CGFloat = 50, height: CGFloat = 50) {
        self.id = id
        self.pos = pos
        self.rotationDegree = rotationDegree
        self.width = width
        self.height = height
        zIndex = Date().timeIntervalSince1970
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let posX = try container.decode(CGFloat.self, forKey: .posX)
        let posY = try container.decode(CGFloat.self, forKey: .posY)
        pos = CGPoint(x: posX, y: posY)
        rotationDegree = try container.decode(CGFloat.self, forKey: .rotationDegree)
        zIndex = try container.decode(Double.self, forKey: .zIndex)
        width = try container.decode(CGFloat.self, forKey: .width)
        height = try container.decode(CGFloat.self, forKey: .height)
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(pos.x, forKey: .posX)
        try container.encode(pos.y, forKey: .posY)
        try container.encode(rotationDegree, forKey: .rotationDegree)
        try container.encode(zIndex, forKey: .zIndex)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
    }

    public func onDragChanged(translation: CGSize) {
        offset = .init(x: translation.width, y: translation.height)
    }

    public func onDragEnd() {
        pos = .init(x: pos.x + offset.x, y: pos.y + offset.y)
        offset = .zero
    }

    public static func == (lhs: MovableObject, rhs: MovableObject) -> Bool {
        return lhs.id == rhs.id
            && lhs.pos == rhs.pos
            && lhs.rotationDegree == rhs.rotationDegree
            && lhs.zIndex == rhs.zIndex
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }

    open func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(pos.x)
        hasher.combine(pos.y)
        hasher.combine(rotationDegree)
        hasher.combine(zIndex)
        hasher.combine(width)
        hasher.combine(height)
    }
}
