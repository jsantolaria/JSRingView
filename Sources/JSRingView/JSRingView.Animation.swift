//
//  JSRingView.Animation.swift
//  JSRingView
//
//  Created by JP Santolaria on 22/09/2024.
//

import Foundation
import UIKit

public extension JSRingView {
    
    struct Animation {
        
        public static let `default`: Self = .init(speed: 1.25, segmentsCount: 32, segmentsCap: .round, isGradientRotationEnabled: true)
        
        /// Animation speed.
        public let speed: CGFloat
        /// Number of segments.
        public let segmentsCount: Int
        /// Cap of segments
        public let segmentsCap: CAShapeLayerLineCap
        /// Ring should rotate ?
        public let isRingRotationEnabled: Bool
        /// Gradient should rotate ?
        public let isGradientRotationEnabled: Bool
        
        public init(
            speed: CGFloat = 1.25,
            segmentsCount: Int = 32,
            segmentsCap: CAShapeLayerLineCap = .round,
            isRingRotationEnabled: Bool = true,
            isGradientRotationEnabled: Bool = true
        ) {
            self.speed = speed
            self.segmentsCount = segmentsCount
            self.segmentsCap = segmentsCap
            self.isRingRotationEnabled = isRingRotationEnabled
            self.isGradientRotationEnabled = isGradientRotationEnabled
        }
    }
    
}
