//
//  JSRingView.Animation.swift
//  JSRingView
//
//  Created by JP Santolaria on 21/09/2024.
//

import UIKit

extension JSRingView {
    
    struct AnimationCurve {
        
        /// Default configuration (Instagram like)
        static let `default`: Self = .init(frequency: 0.45, yOffset: 0.862, xOffset: 0.1, amplitude: 2.746)
        
        /// Frequency (hertz) of sine curve.
        let frequency: CGFloat
        /// Y translation of sine curve.
        let yOffset: CGFloat
        /// X translation of sine curve.
        let xOffset: CGFloat
        /// Amplitude of sine curve.
        let amplitude: CGFloat
        
        // MARK: Initializers
        
        init(frequency: CGFloat, yOffset: CGFloat, xOffset: CGFloat, amplitude: CGFloat) {
            self.frequency = frequency
            self.yOffset = yOffset
            self.xOffset = xOffset
            self.amplitude = amplitude
        }
    }
    
}

