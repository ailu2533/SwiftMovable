//
//  File.swift
//
//
//  Created by ailu on 2024/4/30.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}

struct ReadSizeViewModifier: ViewModifier {
    let callback: (CGSize) -> Void

    func body(content: Content) -> some View {
        return content.background(content: {
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

extension View {
    public func readSize(callback: @escaping (CGSize) -> Void) -> some View {
        return modifier(ReadSizeViewModifier(callback: callback))
    }
}

struct MaxWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct MaxWidthViewModifier: ViewModifier {
    let callback: (CGFloat) -> Void

    func body(content: Content) -> some View {
        return content.background(content: {
            GeometryReader(content: { geometry in
                Color.clear.onAppear(perform: {
                    callback(geometry.size.width)
                })
                .preference(key: SizePreferenceKey.self, value: geometry.size)
                .onPreferenceChange(SizePreferenceKey.self, perform: { size in
                    callback(size.width)
                })
            })
        })
    }
}

extension View {
    public func maxWidth(callback: @escaping (CGFloat) -> Void) -> some View {
        return modifier(MaxWidthViewModifier(callback: callback))
    }
}
