//
//  MaskView.swift
//  Matrix Animation
//
//  Created by GE-Developer
//

import SwiftUI

// MARK: - MaskView
struct MaskView: View {
    @State private var shouldAnimate = false
    
    private let width: CGFloat
    private let height: CGFloat
    private let speedRange: ClosedRange<Double>
    
    private let gradientMask = LinearGradient(
        colors: [.clear, .black.opacity(0.5), .black.opacity(0.9), .black],
        startPoint: .top,
        endPoint: .bottom
    )
    
    init(width: CGFloat, height: CGFloat, speedRange: ClosedRange<Double>) {
        self.width = width
        self.height = height
        self.speedRange = speedRange
    }
    
    var body: some View {
        mask()
            .onAppear { startAnimation() }
    }
}

// MARK: - MaskView (Builder)
extension MaskView {
    @ViewBuilder
    private func mask() -> some View {
        let maskHeight = height / CGFloat.random(in: 1.2...2.6)
        let xOffset = shouldAnimate ? height : -maskHeight
        
        VStack(spacing: 0) {
            Rectangle()
                .fill(gradientMask)
                .frame(height: maskHeight)
            Spacer()
        }
        .frame(width: width)
        .offset(y: xOffset)
    }
}

// MARK: - MaskView (Logic)
extension MaskView {
    private func startAnimation() {
        let delay: Double = .random(in: 0...4)
        
        withAnimation(.linear(duration: .random(in: speedRange))
            .delay(delay)
            .repeatForever(autoreverses: false)) {
                shouldAnimate = true
            }
    }
}
