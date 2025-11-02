//
//  MovableObjectProtocol.swift
//
//
//  Created by ailu on 2024/7/12.
//

import Foundation

import SwiftUI

// MARK: - MovableObjectProtocol

protocol MovableObjectProtocol: Identifiable {
    var id: UUID { get }
    var offset: CGPoint { get set }
    var pos: CGPoint { get set }
    var rotationDegree: CGFloat { get set }
    var zIndex: Double { get set }
    var width: CGFloat { get set }
    var height: CGFloat { get set }

    // PERIPHERY: Unused function.method.instance 'onDragChanged(translation:)'
    // func onDragChanged(translation: CGSize)
    // PERIPHERY: Unused function.method.instance 'onDragEnd()'
    // func onDragEnd()
    // PERIPHERY: Unused function.operator.infix '==(_:_:)'
    // static func == (lhs: Self, rhs: Self) -> Bool
    // PERIPHERY: Unused function.method.instance 'hash(into:)'
    // func hash(into hasher: inout Hasher)
    // }

    // extension MovableObjectProtocol where Self: Hashable {
    // PERIPHERY: Unused function.operator.infix '==(_:_:)'
    // static func == (lhs: Self, rhs: Self) -> Bool {
    // lhs.id == rhs.id
    // && lhs.pos == rhs.pos
    // && lhs.rotationDegree == rhs.rotationDegree
    // && lhs.zIndex == rhs.zIndex
    // && lhs.width == rhs.width
    // && lhs.height == rhs.height
    // }

    // PERIPHERY: Unused function.method.instance 'hash(into:)'
    // func hash(into hasher: inout Hasher) {
    // hasher.combine(id)
    // hasher.combine(pos.x)
    // hasher.combine(pos.y)
    // hasher.combine(rotationDegree)
    // hasher.combine(zIndex)
    // hasher.combine(width)
    // hasher.combine(height)
    // }
}
