//
//  File.swift
//
//
//  Created by ailu on 2024/7/12.
//

import Foundation
import SwiftUI

public struct CircleButtonStyle2: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    public init() {
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(5)
//            .foregroundStyle(configuration.role == .destructive ? .red : .white)
            .clipShape(Circle())
//            .shadow(radius: 1)
            .saturation(isEnabled ? 1 : 0)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .frame(width: 30, height: 30)
            .contentShape(Rectangle())
    }
}
