//
//  JSRingView.Configuration.swift
//  JSRingView
//
//  Created by JP Santolaria on 21/09/2024.
//

import UIKit

public extension JSRingView {
    
    struct Appearance {
        
        public struct Gradient {
            
            // MARK: Properties
            
            /// Colors of gradients.
            public let colors: [UIColor]
            /// Locations of colors.
            public let locations: [CGFloat]
            /// Angle of gradient
            public let angle: CGFloat
            
            // MARK: Initializers
            
            public init(colors: [UIColor], locations: [CGFloat], angle: CGFloat = 0) {
                self.colors = colors
                self.locations = locations
                self.angle = angle
            }
            
            public init(color: UIColor) {
                self.colors = Array(repeating: color, count: 2)
                self.locations = [0, 1]
                self.angle = 0
            }
        }
        
        // MARK: Properties
        
        /// Instagram appearance.
        public static let instagram: Self = .init(
            gradient: .init(
                colors: [
                    .init(red: 226.0 / 255.0, green: 1.0 / 255.0, blue: 203.0 / 255.0, alpha: 1),
                    .init(red: 251.0 / 255.0, green: 40.0 / 255.0, blue: 21.0 / 255.0, alpha: 1),
                    .init(red: 251.0 / 255.0, green: 198.0 / 255.0, blue: 12.0 / 255.0, alpha: 1)
                ],
                locations: [0, 0.5, 1],
                angle: .pi / 4
            ),
            ringThickness: .relative(0.08)
        )
        /// Gradient of the ring.
        public let gradient: Gradient
        /// Thickness of the ring.
        public let ringThickness: RingThickness
        
        // MARK: Initializers
        
        public init(gradient: Gradient, ringThickness: RingThickness = .relative(0.1)) {
            self.gradient = gradient
            self.ringThickness = ringThickness
        }
        
        public init(color: UIColor, ringThickness: RingThickness = .relative(0.1)) {
            self.gradient = .init(color: color)
            self.ringThickness = ringThickness
        }
    }
    
}

// MARK: - RingThickness

public extension JSRingView.Appearance {
        
    enum RingThickness {
        /// Absolute value of thickness.
        case absolute(CGFloat)
        /// Relative value of thickness. It depends on ring radius.
        case relative(CGFloat)
    }
    
}
