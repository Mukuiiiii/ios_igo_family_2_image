import SwiftUI

/// 以兩段二次貝茲曲線繪製 BB-8 的圓頂頭部外框。
private struct BB8HeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        path.closeSubpath()
        return path
    }
}

/// 使用 SwiftUI 基本圖形組合而成的 BB-8 向量插圖。
struct BB8: View {
    // 集中定義角色色票，確保頭部、身體與面板的配色一致。
    private let orange = Color(red: 0.95, green: 0.48, blue: 0.10)
    private let shell = Color(red: 0.96, green: 0.97, blue: 0.97)
    private let metal = Color(red: 0.55, green: 0.59, blue: 0.62)
    private let bodyRotationSpeed = 90.0

    var body: some View {
        TimelineView(.animation) { timeline in
            // 負角度代表逆時針旋轉；每四秒取餘數可避免角度持續無限增長。
            let elapsed = timeline.date.timeIntervalSinceReferenceDate
                .truncatingRemainder(dividingBy: 4)
            let bodyRotation = -elapsed * bodyRotationSpeed

            ZStack {
                robotBody
                    .rotationEffect(.degrees(bodyRotation))
                    .position(x: 150, y: 257)

                // 頭部不跟著球形身體旋轉，維持 BB-8 滾動時的姿態。
                robotHead
                    .rotationEffect(.degrees(-8))
                    .position(x: 140, y: 96)
            }
        }
        .frame(width: 300, height: 380)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("BB-8")
    }

    /// 球形身體由外殼、接縫曲線及三個裝甲面板疊加而成。
    private var robotBody: some View {
        ZStack {
            Circle()
                .fill(shell)

            Path { path in
                path.move(to: CGPoint(x: 29, y: 25))
                path.addQuadCurve(
                    to: CGPoint(x: 204, y: 197),
                    control: CGPoint(x: 69, y: 162)
                )
                path.move(to: CGPoint(x: 7, y: 147))
                path.addQuadCurve(
                    to: CGPoint(x: 218, y: 63),
                    control: CGPoint(x: 114, y: 153)
                )
            }
            .stroke(metal.opacity(0.45), lineWidth: 2)

            bodyPanel
                .frame(width: 89, height: 89)
                .scaleEffect(x: 1.2, y: 0.95)
                .rotationEffect(.degrees(-55))
                .position(x: 26, y: 59)

            bodyPanel
                .frame(width: 83, height: 83)
                .scaleEffect(x: 1, y: 0.66)
                .rotationEffect(.degrees(22))
                .position(x: 87, y: 215)

            bodyPanel
                .frame(width: 110, height: 110)
                .rotationEffect(.degrees(50))
                .position(x: 153, y: 107)
        }
        .frame(width: 228, height: 228)
        .clipShape(Circle())
        .overlay(Circle().stroke(metal.opacity(0.6), lineWidth: 2))
    }

    /// 可重複使用的圓形裝甲面板，內部線寬與元件尺寸皆按容器縮放。
    private var bodyPanel: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                Circle()
                    .fill(shell)

                Circle()
                    .strokeBorder(orange, lineWidth: size * 0.12)

                Circle()
                    .strokeBorder(orange, lineWidth: size * 0.035)
                    .padding(size * 0.2)

                // 將同一矩形每 90 度旋轉一次，形成四向放射狀橘色接點。
                ForEach(0..<4) { index in
                    Rectangle()
                        .fill(orange)
                        .frame(width: size * 0.12, height: size * 0.18)
                        .offset(y: -size * 0.30)
                        .rotationEffect(.degrees(Double(index) * 90))
                }

                Circle()
                    .fill(metal.opacity(0.25))
                    .frame(width: size * 0.30, height: size * 0.30)

                Circle()
                    .strokeBorder(metal, lineWidth: 2)
                    .frame(width: size * 0.30, height: size * 0.30)

                RoundedRectangle(cornerRadius: 2)
                    .fill(metal)
                    .frame(width: size * 0.1, height: size * 0.2)
            }
            .frame(width: size, height: size)
        }
    }

    /// 頭部包含天線、外殼飾帶、主鏡頭與輔助感測器。
    private var robotHead: some View {
        ZStack {
            Capsule()
                .fill(metal)
                .frame(width: 4, height: 49)
                .position(x: 111, y: 28)

            Capsule()
                .fill(Color.gray.opacity(0.7))
                .frame(width: 3, height: 32)
                .position(x: 131, y: 39)

            ZStack {
                BB8HeadShape()
                    .fill(shell)

                Rectangle()
                    .fill(orange)
                    .frame(width: 170, height: 7)
                    .position(x: 85, y: 21)

                Rectangle()
                    .fill(orange)
                    .frame(width: 170, height: 5)
                    .position(x: 85, y: 72)

                Rectangle()
                    .fill(metal)
                    .frame(width: 170, height: 10)
                    .position(x: 85, y: 85)

                Circle()
                    .fill(metal)
                    .frame(width: 45, height: 45)
                    .position(x: 62, y: 46)

                Circle()
                    .fill(Color(white: 0.10))
                    .frame(width: 36, height: 36)
                    .position(x: 62, y: 46)

                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 10, height: 10)
                    .position(x: 56, y: 39)

                Circle()
                    .fill(metal)
                    .frame(width: 21, height: 21)
                    .position(x: 111, y: 55)

                Circle()
                    .fill(Color(white: 0.15))
                    .frame(width: 14, height: 14)
                    .position(x: 111, y: 55)

                Circle()
                    .fill(Color(white: 0.2))
                    .frame(width: 5, height: 5)
                    .position(x: 135, y: 57)
            }
            .frame(width: 170, height: 90)
            .clipShape(BB8HeadShape())
            .overlay(BB8HeadShape().stroke(metal, lineWidth: 2))
            .position(x: 85, y: 85)
        }
        .frame(width: 170, height: 134)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
        BB8()
}
