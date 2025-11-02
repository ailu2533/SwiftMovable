//
//  IconViewModifier.swift
//
//
//  Created by ailu on 2024/7/13.
//

import Foundation
import SwiftUI

// MARK: - IconViewModifier

struct IconViewModifier: ViewModifier {
    var size: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .padding(8)
            .background(Color(.systemGray6))
            .clipShape(Circle())
            .shadow(radius: 1)
    }
}

extension View {
    func iconStyle(size: CGFloat = 14) -> some View {
        modifier(IconViewModifier(size: size))
    }
}
