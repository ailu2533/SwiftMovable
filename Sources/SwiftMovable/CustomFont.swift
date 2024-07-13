//
//  File.swift
//  
//
//  Created by ailu on 2024/7/13.
//

import Foundation


public struct CustomFont: Identifiable {
    public var id: String {
        return postscriptName
    }

    public let displayName: String
    public let postscriptName: String

    public init(displayName: String, postscriptName: String) {
        self.displayName = displayName
        self.postscriptName = postscriptName
    }
}

extension CustomFont: Hashable {
    public func hash(into hasher: inout Hasher) {
//        hasher.combine(displayName)
        hasher.combine(postscriptName)
    }

    public static func == (lhs: CustomFont, rhs: CustomFont) -> Bool {
        return lhs.postscriptName == rhs.postscriptName
    }
}

extension CustomFont {
    public static var fonts: [CustomFont] {
        [
//            .init(displayName: "得意黑", postscriptName: "SmileySans-Oblique"),
//            .init(displayName: "cjkFonts", postscriptName: "cjkFonts-Regular"),
//            .init(displayName: "霞鹜文楷", postscriptName: "LXGWWenKai-Regular"),
//            .init(displayName: "寒蝉圆黑体", postscriptName: "ChillRoundGothic_Heavy"),
            .init(displayName: "寒蝉全黑体bold", postscriptName: "ChillRoundFBold"),
            .init(displayName: "寒蝉全黑体regular", postscriptName: "ChillRoundFRegular")
//            .init(displayName: "寒蝉活仿宋", postscriptName: "ChillHuoFangSong_Regular"),
//            .init(displayName: "寒蝉活仿宋Bold", postscriptName: "ChillHuoFangSong-ConBold"),
        ]
    }
}
