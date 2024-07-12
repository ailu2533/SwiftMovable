//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/23.
//

import SwiftUI

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
            .init(displayName: "寒蝉全黑体regular", postscriptName: "ChillRoundFRegular"),
//            .init(displayName: "寒蝉活仿宋", postscriptName: "ChillHuoFangSong_Regular"),
//            .init(displayName: "寒蝉活仿宋Bold", postscriptName: "ChillHuoFangSong-ConBold"),
        ]
    }
}

public struct TextStyleEditView: View {
    @Bindable var textItem: TextItem
    private var fontNames: [CustomFont]

    public init(textItem: TextItem, fontNames: [CustomFont]) {
        self.textItem = textItem
        self.fontNames = fontNames
    }

    public var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.blue.opacity(0.2))
                .frame(height: 200)

                .overlay {
                    textItem.view()
                }
                .padding()

            Form {
                LabeledContent {
                    TextField("文字", text: $textItem.text)
                        .submitLabel(.done)
                } label: {
                    Text("文字")
                }

                LabeledContent {
                    HStack(spacing: 0) {
                        Slider(value: $textItem.fontSize, in: 10 ... 60, step: 1)
                        Text("\(Int(textItem.fontSize))")
                            .frame(width: 40)
                    }

                } label: {
                    Text("字体")
                }

//                LabeledContent {
//                    HStack(spacing: 0) {
//                        Slider(value: $textItem.rotationDegree, in: -180 ... 180, step: 1)
//                        Text("\(Int(textItem.rotationDegree))")
//                            .frame(width: 40)
//                    }
//
//                } label: {
//                    Text("旋转")
//                }

//                ColorPicker("颜色", selection: $textItem.color)

                DisclosureGroup(
                    content: {
                        Picker(selection: $textItem.fontName) {
                            ForEach(fontNames, id: \.self) { fontName in
                                Text(fontName.displayName)
                                    .font(.custom(fontName.postscriptName, size: 20))
                                    .tag(fontName.postscriptName)
                            }

                        } label: {
                            Text("字体")
                        }.pickerStyle(.wheel)
                    },
                    label: { Text("字体") }
                )
            }
        }
    }
}

#Preview {
    TextStyleEditView(textItem: .init(text: "hello"), fontNames: CustomFont.fonts)
}
