//
//  File.swift
//  
//
//  Created by ailu on 2024/7/12.
//

import Foundation
import SwiftUI


public struct ViewSizeKey: PreferenceKey {
    public typealias Value = Anchor<CGPoint>?
    public static var defaultValue: Value = nil

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

