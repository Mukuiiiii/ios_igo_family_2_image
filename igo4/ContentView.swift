import SwiftUI

private struct BackgroundTile: Identifiable {
    let id = UUID()
}

/// 依裝置尺寸組合沙漠背景與 BB-8 的主畫面。
struct ContentView: View {
    @State private var backgroundTiles: [BackgroundTile] = []
    @State private var backgroundOffset: CGFloat = 0

    private let backgroundSpeed: CGFloat = 60

    var body: some View {
        // 讀取可用空間，讓背景分片與角色比例能隨螢幕調整。
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let tileAspectRatio: CGFloat = 260.0 / 440.0
            let tileWidth = max(1, height * tileAspectRatio)
            let visibleTileCount = max(
                1,
                Int((width / tileWidth).rounded(.up))
            )
            let requiredTileCount = visibleTileCount + 2

            // BB8 的原始畫布為 300 × 380；取寬高限制中的較小值以保持完整比例。
            let robotScale = min(
                width * 0.72 / 300,
                height * 0.58 / 380
            )

            ZStack(alignment: .topLeading) {
                // 固定背景容器尺寸，避免額外的緩衝分片撐大主畫面並影響角色定位。
                HStack(spacing: 0) {
                    ForEach(backgroundTiles) { _ in
                        DesertBackground()
                            .frame(width: tileWidth, height: height)
                    }
                }
                .offset(x: -tileWidth + backgroundOffset)
                .frame(
                    width: width,
                    height: height,
                    alignment: .topLeading
                )
                .clipped()

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
            .task(id: tileWidth) {
                await moveBackground(
                    tileCount: requiredTileCount,
                    tileWidth: tileWidth
                )
            }
        }
        .ignoresSafeArea()
    }

    @MainActor
    private func moveBackground(tileCount: Int, tileWidth: CGFloat) async {
        backgroundTiles = (0..<tileCount).map { _ in BackgroundTile() }
        backgroundOffset = 0

        let duration = Double(tileWidth / backgroundSpeed)

        while !Task.isCancelled {
            withAnimation(.linear(duration: duration)) {
                backgroundOffset = tileWidth
            }

            do {
                try await Task.sleep(for: .seconds(duration))
            } catch {
                return
            }

            // 最右側背景完全離開畫面後刪除，並在左側補上新的背景。
            withTransaction(Transaction(animation: nil)) {
                if !backgroundTiles.isEmpty {
                    backgroundTiles.removeLast()
                }
                backgroundTiles.insert(BackgroundTile(), at: 0)
                backgroundOffset = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
