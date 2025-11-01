import Foundation
import SwiftUI

struct MultiDirectionResizableModifier<Item: MovableObject>: ViewModifier {
    // MARK: Lifecycle

    init(width: Binding<CGFloat>, height: Binding<CGFloat>, hasBorder _: Bool, item: Item, onResize: @escaping (Item, CGSize) -> CGSize) {
        aspectRatio = width.wrappedValue / height.wrappedValue
        _width = width
        _height = height
        self.onResize = onResize
        self.item = item
    }

    // MARK: Internal

    @State private var pinchMagnification: CGFloat = 1

    @Binding var width: CGFloat
    @Binding var height: CGFloat
    // 宽高比
    let aspectRatio: CGFloat
    let onResize: (Item, CGSize) -> CGSize
    var item: Item

    func body(content: Content) -> some View {
        content
            .frame(width: width * pinchMagnification, height: height * pinchMagnification)
            // Top edge
            .overlay(alignment: .top) {
                DraggableNode(
                    width: $width,
                    height: $height,
                    nodeType: .top,
                    aspectRatio: aspectRatio,
                    item: item,
                    resizeCallback: onResize
                )
            }
            // Left edge
            .overlay(alignment: .leading) {
                DraggableNode(
                    width: $width,
                    height: $height,
                    nodeType: .left,
                    aspectRatio: aspectRatio,
                    item: item,
                    resizeCallback: onResize
                )
            }
            // Right edge
            .overlay(alignment: .trailing) {
                DraggableNode(
                    width: $width,
                    height: $height,
                    nodeType: .right,
                    aspectRatio: aspectRatio,
                    item: item,
                    resizeCallback: onResize
                )
            }

            // Bottom edge
            .overlay(alignment: .bottom) {
                DraggableNode(
                    width: $width,
                    height: $height,
                    nodeType: .bottom,
                    aspectRatio: aspectRatio,
                    item: item,
                    resizeCallback: onResize
                )
            }
    }
}

// MARK: - Preview

#Preview("Multi-Direction Resizable") {
    @Previewable @State var width: CGFloat = 200
    @Previewable @State var height: CGFloat = 150

    let testItem = MovableObject(
        pos: CGPoint(x: 200, y: 200),
        width: 200,
        height: 150
    )

    ZStack {
        Color.gray.opacity(0.1)
            .ignoresSafeArea()

        VStack(spacing: 20) {
            Text("Multi-Direction Resizable Modifier")
                .font(.title2)
                .fontWeight(.bold)

            Text("Drag the handles on all four edges to resize")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            // Resizable content
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                VStack(spacing: 8) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 32))
                        .foregroundColor(.white)

                    Text("Resizable Content")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("\(Int(width)) × \(Int(height))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                }
            }
            .modifier(
                MultiDirectionResizableModifier(
                    width: $width,
                    height: $height,
                    hasBorder: true,
                    item: testItem,
                    onResize: { _, proposedSize in
                        // Constrain minimum and maximum sizes
                        let constrainedWidth = max(100, min(300, proposedSize.width))
                        let constrainedHeight = max(80, min(250, proposedSize.height))
                        return CGSize(width: constrainedWidth, height: constrainedHeight)
                    }
                )
            )

            Spacer()

            // Instructions
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "hand.draw")
                        .foregroundColor(.blue)
                    Text("Drag handles to resize in any direction")
                        .font(.caption)
                }
                HStack {
                    Image(systemName: "arrow.up.and.down")
                        .foregroundColor(.blue)
                    Text("Top/Bottom: Adjust height")
                        .font(.caption)
                }
                HStack {
                    Image(systemName: "arrow.left.and.right")
                        .foregroundColor(.blue)
                    Text("Left/Right: Adjust width")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
    }
}
