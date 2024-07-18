//
//  File.swift
//
//
//  Created by ailu on 2024/7/12.
//

import Foundation

import SwiftUI

protocol MovableObjectProtocol: Identifiable, Codable {
    var id: UUID { get set }
    var offset: CGPoint { get set }
    var pos: CGPoint { get set }
    var rotationDegree: CGFloat { get set }
    var zIndex: Double { get set }
//    var scale: CGFloat { get set }
    var width: CGFloat { get set }
    var height: CGFloat { get set }

    func onDragChanged(translation: CGSize)
    func onDragEnd()
    static func == (lhs: Self, rhs: Self) -> Bool
    func hash(into hasher: inout Hasher)
//    var debugText: String { get }
}

extension MovableObjectProtocol where Self: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
            && lhs.pos == rhs.pos
            && lhs.rotationDegree == rhs.rotationDegree
            && lhs.zIndex == rhs.zIndex
//            && lhs.scale == rhs.scale
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(pos.x)
        hasher.combine(pos.y)
        hasher.combine(rotationDegree)
        hasher.combine(zIndex)
//        hasher.combine(scale)
        hasher.combine(width)
        hasher.combine(height)
    }
}
