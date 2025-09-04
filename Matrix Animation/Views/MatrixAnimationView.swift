//
//  MatrixAnimationView.swift
//  Matrix Animation
//
//  Created by GE-Developer
//

import SwiftUI

// MARK: - MatrixAnimationView
struct MatrixAnimationView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var updateTask: Task<Void, Never>?
    @State private var grid: [[Character]] = []
    
    private let letters: [Character]
    private let color: any ShapeStyle
    private let letterSize: CGFloat
    private let columnSpacing: CGFloat
    private let rowSpacing: CGFloat
    private let updateDelay: Int
    private let speedRange: ClosedRange<Double>
    
    init(
        _ letters: LetterType,
        color: any ShapeStyle,
        letterSize: CGFloat = 15,
        columnSpacing: CGFloat = 2,
        rowSpacing: CGFloat = 1,
        updateDelay: Int = 25,
        speedRange: ClosedRange<Double> = 7...9
    ) {
        self.letters = letters.get
        self.color = color
        self.letterSize = letterSize
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
        self.updateDelay = updateDelay
        self.speedRange = speedRange
    }
    
    var body: some View {
        GeometryReader { geo in
            lettersCanvas(geo.size.width, geo.size.height)
                .mask { matrixMask(geo.size.height) }
                .task {
                    await initGrid(width: geo.size.width, height: geo.size.height)
                    startUpdating()
                }
                .onDisappear { stopUpdating() }
                .onChange(of: scenePhase) { checkUpdatingIfNeeded() }
        }
    }
}

// MARK: - MatrixAnimationView (Builder)
extension MatrixAnimationView {
    private func lettersCanvas(_ width: CGFloat, _ height: CGFloat) -> some View {
        Canvas { context, _ in
            for (colIndex, column) in grid.enumerated() {
                let totalWidth = CGFloat(grid.count) * letterSize + CGFloat(grid.count - 1) * columnSpacing
                let x = CGFloat(colIndex) * (letterSize + columnSpacing) + letterSize / 2 + (width - totalWidth)/2
                
                for (rowIndex, letter) in column.enumerated() {
                    let totalHeight = CGFloat(grid[0].count) * letterSize + CGFloat(grid[0].count - 1) * rowSpacing
                    let y = CGFloat(rowIndex) * (letterSize + rowSpacing) + letterSize / 2 + (height - totalHeight)/2
                    
                    let letterText = Text(String(letter))
                        .font(.system(size: letterSize, weight: .light, design: .monospaced))
                        .foregroundStyle(color)
                    
                    
                    
                    context.draw(letterText, at: CGPoint(x: x, y: y))
                }
            }
        }
    }
    
    private func matrixMask(_ height: CGFloat) -> some View {
        LazyHStack(spacing: columnSpacing) {
            ForEach(0..<grid.count, id: \.self) { _ in
                MaskView(width: letterSize, height: height, speedRange: speedRange)
            }
        }
    }
}

// MARK: - MatrixAnimationView (Logic)
extension MatrixAnimationView {
    private func initGrid(width: CGFloat, height: CGFloat) async {
        let cols = Int((width + columnSpacing) / (letterSize + columnSpacing))
        let rows = Int((height + rowSpacing) / (letterSize + rowSpacing))
        
        guard cols > 0, rows > 0 else { return }
        grid = (0..<cols).map { _ in
            (0..<rows).map { _ in letters.randomElement() ?? "0" }
        }
    }
    
    private func startUpdating() {
        let delay = UInt64(updateDelay * 10_000_000)
        
        updateTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: delay)
                
                guard !grid.isEmpty else { return }
                for col in 0..<grid.count {
                    for _ in 1..<3 {
                        let row = Int.random(in: 0..<grid[col].count)
                        
                        grid[col][row] = letters.randomElement() ?? "0"
                    }
                }
            }
        }
    }
    
    private func stopUpdating() {
        updateTask?.cancel()
        updateTask = nil
    }
    
    private func checkUpdatingIfNeeded() {
        switch scenePhase {
        case .active:
            startUpdating()
        case .inactive, .background:
            stopUpdating()
        @unknown default:
            stopUpdating()
        }
    }
}
