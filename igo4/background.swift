import SwiftUI

/// 以兩段貝茲曲線建立左右對稱的沙丘上緣。
private struct DesertWave: Shape {
    let edgeHeight: CGFloat
    let middleHeight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let edgeY = rect.height * edgeHeight
        let middleY = rect.height * middleHeight
        path.move(to: CGPoint(x: 0, y: edgeY))

        path.addCurve(
            to: CGPoint(x: rect.width * 0.5, y: middleY),
            control1: CGPoint(x: rect.width * 0.18, y: edgeY),
            control2: CGPoint(x: rect.width * 0.32, y: middleY)
        )

        path.addCurve(
            to: CGPoint(x: rect.width, y: edgeY),
            control1: CGPoint(x: rect.width * 0.68, y: middleY),
            control2: CGPoint(x: rect.width * 0.82, y: edgeY)
        )
        return path
    }
}

/// 將沙丘上緣向畫面底部封閉，形成可填色的完整區域。
private struct DesertDune: Shape {
    let edgeHeight: CGFloat
    let middleHeight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = DesertWave(
            edgeHeight: edgeHeight,
            middleHeight: middleHeight
        ).path(in: rect)
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

private struct DesertMountains: Shape {
    func path(in rect: CGRect) -> Path {
        // 使用 0...1 的標準化座標，讓山脈輪廓能等比例適應任意畫布。
        let points: [CGPoint] = [
            CGPoint(x: 0.00, y: 0.52),
            CGPoint(x: 0.08, y: 0.52),
            CGPoint(x: 0.14, y: 0.48),
            CGPoint(x: 0.19, y: 0.39),
            CGPoint(x: 0.27, y: 0.39),
            CGPoint(x: 0.32, y: 0.47),
            CGPoint(x: 0.46, y: 0.53),
            CGPoint(x: 0.59, y: 0.49),
            CGPoint(x: 0.68, y: 0.51),
            CGPoint(x: 0.78, y: 0.44),
            CGPoint(x: 0.86, y: 0.46),
            CGPoint(x: 0.93, y: 0.52),
            CGPoint(x: 1.00, y: 0.52)
        ]

        var path = Path()
        for (index, point) in points.enumerated() {
            let position = CGPoint(
                x: point.x * rect.width,
                y: point.y * rect.height
            )
            if index == 0 {
                path.move(to: position)
            } else {
                path.addLine(to: position)
            }
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

private struct DesertRock: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.85))
        path.addLine(to: CGPoint(x: rect.width * 0.18, y: rect.height * 0.30))
        path.addLine(to: CGPoint(x: rect.width * 0.55, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 0.84, y: rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.90))
        path.addLine(to: CGPoint(x: rect.width * 0.45, y: rect.height))
        path.closeSubpath()
        return path
    }
}
/// 由天空、遠山、前後沙丘與岩石依序疊成的響應式沙漠背景。
struct DesertBackground: View {
    var body: some View {

        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            
            // ZStack 的宣告順序即景深：先畫遠景，再覆蓋近景。
            ZStack {
                
                LinearGradient(
                    colors: [
                        Color(red: 0.40, green: 0.57, blue: 0.64),
                        Color(red: 0.83, green: 0.76, blue: 0.63),
                        Color(red: 1.00, green: 0.85, blue: 0.61)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                DesertMountains()
                    .fill(Color(red: 0.65, green: 0.59, blue: 0.50))
                
                DesertDune(edgeHeight: 0.55, middleHeight: 0.58)
                    .fill(Color(red: 0.89, green: 0.73, blue: 0.50))
                
                DesertDune(edgeHeight: 0.78, middleHeight: 0.75)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.88, green: 0.68, blue: 0.43),
                                Color(red: 0.69, green: 0.47, blue: 0.28)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                DesertRock()
                    .fill(Color(red: 0.46, green: 0.36, blue: 0.27))
                    .frame(width: w * 0.11, height: h * 0.035)
                    .position(x: w * 0.11, y: h * 0.86)
                
                DesertRock()
                    .fill(Color(red: 0.55, green: 0.41, blue: 0.28))
                    .frame(width: w * 0.045, height: h * 0.018)
                    .position(x: w * 0.30, y: h * 0.875)
                
                DesertRock()
                    .fill(Color(red: 0.58, green: 0.44, blue: 0.30))
                    .frame(width: w * 0.075, height: h * 0.024)
                    .position(x: w * 0.87, y: h * 0.73)
            }
            .frame(width: w, height: h)
            .clipped()
        }
    }
}

#Preview() {
    HStack(spacing: 0) {
        DesertBackground()
            .frame(width: 400, height: 900)
        
    }
}
