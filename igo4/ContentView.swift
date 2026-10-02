import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height

                    let tileCount = max(
                        1,
                        Int((width / 390).rounded(.up))
                    )
                    let tileWidth = width / CGFloat(tileCount)

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
