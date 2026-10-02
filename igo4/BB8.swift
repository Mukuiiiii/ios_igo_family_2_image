//
//  BB8.swift
//  igo4
//
//  Created by user06 on 2026/10/2.
//

import SwiftUI

/// 簡易版 BB-8：只使用 SwiftUI 內建圖形，不需要圖片素材。
/// 使用方式：在你自己的畫面中放入 BB8View() 即可。
struct BB8: View {
    private let orange = Color(red: 0.95, green: 0.48, blue: 0.10)
    private let shell = Color(red: 0.96, green: 0.97, blue: 0.97)
    private let metal = Color(red: 0.55, green: 0.59, blue: 0.62)

    var body: some View {
        // ZStack 會依序疊放圖形；後面宣告的頭部會蓋在身體前面。
        // 固定畫布為 300 × 380，座標與尺寸的單位都是 point。
        ZStack {
            robotBody
                .position(x: 150, y: 257)

            robotHead
                .rotationEffect(.degrees(-8))
                .position(x: 140, y: 96)
        }
        .frame(width: 300, height: 380)
        // 不設定 background，讓圖案可以放在任何背景上。
        // 裝飾圖形合併成一個 VoiceOver 標籤。
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("BB-8 機器人")
    }

    // MARK: - 球形身體

    private var robotBody: some View {
        ZStack {
            Circle()
                .fill(shell)

            // Path 用來畫身體外殼的接縫；move 是起點，addQuadCurve 是曲線。
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

            // 左側和下方的圓環超出身體邊緣，稍後由 clipShape 裁切。
            bodyPanel
                .frame(width: 89, height: 89)
                .scaleEffect(x: 0.64, y: 1)
                .rotationEffect(.degrees(-28))
                .position(x: 26, y: 59)

            bodyPanel
                .frame(width: 83, height: 83)
                .scaleEffect(x: 1, y: 0.66)
                .rotationEffect(.degrees(22))
                .position(x: 87, y: 215)

            // 正面的主圓環最大，也最容易辨識。
            bodyPanel
                .frame(width: 110, height: 110)
                .rotationEffect(.degrees(18))
                .position(x: 153, y: 107)
        }
        .frame(width: 228, height: 228)
        .clipShape(Circle())
        .overlay(Circle().stroke(metal.opacity(0.6), lineWidth: 2))
    }

    // MARK: - 可重複使用的橘色圓環

    private var bodyPanel: some View {
        // GeometryReader 取得外部指定的尺寸，讓同一個圓環可以有不同大小。
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                Circle()
                    .fill(shell)

                // strokeBorder 讓線條畫在圓形內側，避免粗線超出邊界。
                Circle()
                    .strokeBorder(orange, lineWidth: size * 0.12)

                Circle()
                    .strokeBorder(orange, lineWidth: size * 0.035)
                    .padding(size * 0.19)

                // 四個小接片用 ForEach 產生，再依序旋轉 90 度。
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
                    .frame(width: size * 0.09, height: size * 0.18)
            }
            .frame(width: size, height: size)
        }
    }

    // MARK: - 頭部與天線

    private var robotHead: some View {
        ZStack {
            // 天線先畫，底端就會自然被後面的頭殼遮住。
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

                // 主鏡頭：灰色外框、黑色鏡片，再加一點白色反光。
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

                // 右側的小感應器。
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
            .position(x: 85, y: 86)
        }
        .frame(width: 170, height: 134)
    }
}

/// 自訂 Shape 只負責提供輪廓，顏色與外框交給 View 決定。
/// 座標依照 rect 的寬高計算，畫出圓頂、平底的頭殼。
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

#Preview(traits: .sizeThatFitsLayout) {
    BB8()
}
