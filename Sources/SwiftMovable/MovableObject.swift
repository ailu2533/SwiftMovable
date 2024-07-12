//
//  File.swift
//
//
//  Created by ailu on 2024/4/27.
//

import Foundation
import SwiftUI

protocol MovableObjectProtocol: Identifiable, Codable {
    var id: UUID { get set }
    var offset: CGPoint { get set }
    var pos: CGPoint { get set }
    var rotationDegree: CGFloat { get set }
    var zIndex: Double { get set }
    var scale: CGFloat { get set }
    var width: CGFloat { get set }
    var height: CGFloat { get set }

    func onDragChanged(translation: CGSize)
    func onDragEnd()
    static func == (lhs: Self, rhs: Self) -> Bool
    func hash(into hasher: inout Hasher)
    var debugText: String { get }
}

extension MovableObjectProtocol where Self: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
            && lhs.pos == rhs.pos
            && lhs.rotationDegree == rhs.rotationDegree
            && lhs.zIndex == rhs.zIndex
            && lhs.scale == rhs.scale
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(pos.x)
        hasher.combine(pos.y)
        hasher.combine(rotationDegree)
        hasher.combine(zIndex)
        hasher.combine(scale)
        hasher.combine(width)
        hasher.combine(height)
    }
}

@Observable
open class MovableObject: MovableObjectProtocol, Equatable {
    @ObservationIgnored public var id: UUID
    public var offset: CGPoint = .zero
    public var pos: CGPoint = .zero
    public var rotationDegree: CGFloat = .zero
    public var zIndex: Double = 1.0
    public var scale: CGFloat = 1.0

    public var width: CGFloat = 0
    public var height: CGFloat = 0

    enum CodingKeys: String, CodingKey {
        case id
        case posX
        case posY
        case rotationDegree
        case zIndex
        case scale
        case width
        case height
    }

    public init(id: UUID = UUID(), pos: CGPoint, rotationDegree: CGFloat = .zero) {
        self.id = id
        self.pos = pos
        self.rotationDegree = rotationDegree
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let posX = try container.decode(CGFloat.self, forKey: .posX)
        let posY = try container.decode(CGFloat.self, forKey: .posY)
        pos = CGPoint(x: posX, y: posY)
        rotationDegree = try container.decode(CGFloat.self, forKey: .rotationDegree)
        zIndex = try container.decode(Double.self, forKey: .zIndex)
        scale = try container.decode(CGFloat.self, forKey: .scale)
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
        try container.encode(scale, forKey: .scale)
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
            && lhs.scale == rhs.scale
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }

    open func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(pos.x)
        hasher.combine(pos.y)
        hasher.combine(rotationDegree)
        hasher.combine(zIndex)
        hasher.combine(scale)
        hasher.combine(width)
        hasher.combine(height)
    }

    public var debugText: String {
        return "MovableObject(id: \(id), position: (\(pos.x), \(pos.y)), rotationDegree: \(rotationDegree), zIndex: \(zIndex), scale: \(scale))"
    }
}
