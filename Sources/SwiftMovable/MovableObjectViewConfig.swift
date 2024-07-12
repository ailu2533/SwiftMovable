//
//  File.swift
//  
//
//  Created by ailu on 2024/7/12.
//

import Foundation

public struct MovableObjectViewConfig {
    public var parentSize: CGSize?
    public var enable: Bool
    public var deleteCallback: (MovableObject) -> Void
    public var editCallback: (MovableObject) -> Void
    public var tapCallback: (MovableObject) -> Void = { _ in }
//    public var coordinateSpaceId: UUID

    public init(parentSize: CGSize? = nil, enable: Bool = true, deleteCallback: @escaping (MovableObject) -> Void = { _ in }, editCallback: @escaping (MovableObject) -> Void = { _ in }) {
        self.parentSize = parentSize
        self.enable = enable
        self.deleteCallback = deleteCallback
        self.editCallback = editCallback
    }
}
