//
//  String+size.swift
//  SwiftMovable
//
//  Created by Lu Ai on 2025/11/19.
//

import UIKit

public extension String {
    /// 计算文本渲染所需的尺寸
    ///
    /// 使用 NSString 的 boundingRect 方法计算文本在给定字体和字号下所需的空间。
    /// 这个方法会返回能够完整显示文本所需的最小尺寸。
    ///
    /// - Parameters:
    ///   - font: 字体（如果未指定，使用系统默认字体）
    ///   - fontSize: 字体大小
    ///   - maxWidth: 可选的最大宽度限制，用于多行文本计算
    /// - Returns: 文本渲染所需的尺寸
    ///
    /// 使用示例：
    /// ```swift
    /// let text = "Hello, World!"
    /// let size = text.calculateTextSize(font: .systemFont(ofSize: 16), fontSize: 16)
    /// print("Text size: \(size)")
    /// ```
    func calculateTextSize(
        font: UIFont? = nil,
        fontSize: CGFloat,
        maxWidth: CGFloat = .greatestFiniteMagnitude
    ) -> CGSize {
        let actualFont = font ?? .systemFont(ofSize: fontSize)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: actualFont,
        ]

        let constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)

        let boundingRect = (self as NSString).boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )

        // 向上取整以确保有足够空间
        return CGSize(
            width: ceil(boundingRect.width),
            height: ceil(boundingRect.height)
        )
    }

    /// 根据可用空间计算合适的字体大小
    ///
    /// 使用二分查找算法找到能够适配给定空间的最大字体大小。
    /// 这个方法会在 minFontSize 和 maxFontSize 之间进行搜索，
    /// 找到能够让文本完整显示在 availableSize 内的最大字号。
    ///
    /// - Parameters:
    ///   - font: 字体（如果未指定，使用系统默认字体）
    ///   - availableSize: 可用的显示空间
    ///   - maxFontSize: 最大字体大小限制（默认 100）
    ///   - minFontSize: 最小字体大小限制（默认 8）
    ///   - tolerance: 二分查找的精度（默认 0.5）
    ///   - allowsWrapping: 是否允许自动换行（默认 true）。如果为 false，只在显式换行符处换行
    /// - Returns: 能够适配给定空间的字体大小
    ///
    /// 使用示例：
    /// ```swift
    /// let text = "Hello, World!"
    /// let availableSize = CGSize(width: 200, height: 50)
    /// let fontSize = text.calculateFontSize(
    ///     font: .systemFont(ofSize: 1),
    ///     availableSize: availableSize,
    ///     maxFontSize: 50,
    ///     minFontSize: 12,
    ///     allowsWrapping: false
    /// )
    /// print("Optimal font size: \(fontSize)")
    /// ```
    func calculateFontSize(
        font: UIFont? = nil,
        availableSize: CGSize,
        maxFontSize: CGFloat = 100,
        minFontSize: CGFloat = 1,
        tolerance: CGFloat = 0.1,
        allowsWrapping: Bool = true
    ) -> CGFloat {
        // 边界检查
        guard !isEmpty else { return minFontSize }
        guard availableSize.width > 0, availableSize.height > 0 else { return minFontSize }
        guard maxFontSize > minFontSize else { return minFontSize }

        var low = minFontSize
        var high = maxFontSize
        var bestFit = minFontSize

        // 确定计算时使用的最大宽度
        let calculationMaxWidth: CGFloat = allowsWrapping ? availableSize.width : .greatestFiniteMagnitude

        // 二分查找最佳字体大小
        while high - low > tolerance {
            let mid = (low + high) / 2
            let testFont = font?.withSize(mid) ?? .systemFont(ofSize: mid)
            let textSize = calculateTextSize(font: testFont, fontSize: mid, maxWidth: calculationMaxWidth)

            if textSize.width <= availableSize.width, textSize.height <= availableSize.height {
                // 当前字号可以适配，尝试更大的字号
                bestFit = mid
                low = mid
            } else {
                // 当前字号太大，尝试更小的字号
                high = mid
            }
        }

        return bestFit
    }
}
