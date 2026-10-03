import SwiftUI

/// 依裝置尺寸組合沙漠背景與 BB-8 的主畫面。
struct ContentView: View {
    var body: some View {
        // 讀取可用空間，讓背景分片與角色比例能隨螢幕調整。
        GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
            
                    let tileAspectRatio: CGFloat = 260.0 / 440.0
            
                    let tileWidth = max(1, height * tileAspectRatio)

                    let tileCount = max(
                            1,
                            Int((width / tileWidth).rounded(.up))
                    )
                    // BB8 的原始畫布為 300 × 380；取寬高限制中的較小值以保持完整比例。
                    let robotScale = min(
                        width * 0.72 / 300,
                        height * 0.58 / 380
                    )

                    let sunSize = min(width * 0.30, height * 0.25)

                    ZStack {
                        HStack(spacing: 0) {
                            ForEach(0..<tileCount, id: \.self) { _ in
                                DesertBackground()
                                    .frame(
                                        width: tileWidth,
                                        height: height
                                    )
                            }
                        }

                        // 角色水平置中，並以縮放後的半高修正位置，使底部落在畫面約 93% 處。
                        BB8()
                            .scaleEffect(robotScale)
                            .position(
                                x: width * 0.5,
                                y: height * 0.93 - 190 * robotScale
                            )
                    }
                    .frame(width: width, height: height)
                    .clipped()
                }
                .ignoresSafeArea()
            }
}

#Preview {
    ContentView()
}
