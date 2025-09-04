//
//  MatrixAnimationApp.swift
//  Matrix Animation
//
//  Created by GE-Developer
//

import SwiftUI

@main
struct MatrixAnimationApp: App {
    var body: some Scene {
        WindowGroup {
            MatrixAnimationView(.englishCapitalizedAlphabet, color: .cyan)
                .frame(width: 300, height: 300)
                .preferredColorScheme(.dark)
        }
    }
}
