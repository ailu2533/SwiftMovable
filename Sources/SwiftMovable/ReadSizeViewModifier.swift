//
//  ReadSizeViewModifier.swift
//
//
//  Created by ailu on 2024/4/30.
//

import SwiftUI

// MARK: - SizePreferenceKey

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

// MARK: - ReadSizeViewModifier

struct ReadSizeViewModifier: ViewModifier {
    let callback: (CGSize) -> Void

    func body(content: Content) -> some View {
        content.background(content: {
            GeometryReader(content: { geometry in
                Color.clear.onAppear(perform: {
                    callback(geometry.size)
                })
                .preference(key: SizePreferenceKey.self, value: geometry.size)
                .onPreferenceChange(SizePreferenceKey.self, perform: { size in
                    callback(size)
                })
            })
        })
    }
}

public extension View {
    func readSize(callback: @escaping (CGSize) -> Void) -> some View {
        modifier(ReadSizeViewModifier(callback: callback))
    }
}
