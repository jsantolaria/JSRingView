//
//  JSRingView.swift
//  JSRingView
//
//  Created by JP Santolaria on 21/09/2024.
//

import UIKit

public class JSRingView: UIView {
    
    // MARK: Properties
    
    /// A Boolean value that controls whether the activity indicator is hidden when the animation is stopped.
    public var hidesWhenStopped: Bool = false
    /// A Boolean value indicating whether the ring is currently running its animation.
    public private(set) var isAnimating: Bool = false
    /// Appearance configuration.
    public var appearance: Appearance = .instagram {
        didSet { configureAppearance() }
    }
    /// Animation configuration.
    public var animation: Animation = .default
    /// Animation curve configuration.
    private var animationCurve: AnimationCurve = .default
    /// Layer of the gradient
    private let gradientLayer: CAGradientLayer = .init()
    /// Layer of the ring
    private let ringShapeLayer: CAShapeLayer = .init()
    /// Display link
    private var displayLink: CADisplayLink?
    /// Date when animation started
    private var animationStartDate: Date = Date()
    /// Animation time (elapsed time since animation start multiplied by animation speed)
    private var animationTime: TimeInterval = 0.0
    /// Soft stops the animation
    private var softStopAnimation: Bool = false
    
    // MARK: Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        // Setup Gradient Layer
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
        
        // Setup Ring Layer
        ringShapeLayer.fillColor = UIColor.clear.cgColor
        ringShapeLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(ringShapeLayer)
        ringShapeLayer.path = ringPath().cgPath
        
        // Set ring layer as gradient mask
        gradientLayer.mask = ringShapeLayer
        
        // Recompute dash
        updateRingDashPattern()
        // Configure appearance
        configureAppearance()
    }
    
    // MARK: UIView LifeCycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutRing()
    }

    // MARK: Public Methods
    
    /// Start the animation of the ring.
    public func startAnimating() {
        isHidden = false
        isAnimating = true
        softStopAnimation = false
        animationStartDate = Date()
        displayLink = .init(target: self, selector: #selector(animate))
        if #available(iOS 15.0, *) {
            displayLink?.preferredFrameRateRange = .init(minimum: 60, maximum: 120, __preferred: 120)
        }
        displayLink?.add(to: .main, forMode: .common)
    }
    
    /// Stop the animation of the ring.
    ///
    /// - Parameter soft: If `true`, the animation will be stopped when the ring is filled, else, animation will stop without transition.
    public func stopAnimating(soft: Bool = true) {
        isAnimating = false
        softStopAnimation = soft
        
        if !soft {
            displayLink?.invalidate()
            displayLink = nil
            reset()
            if hidesWhenStopped {
                isHidden = true
            }
        }
    }
    
    // MARK: Private Methods
    
    /// Layout the ring to fit view.
    private func layoutRing() {
        gradientLayer.frame = bounds
        ringShapeLayer.frame = bounds
        ringShapeLayer.path = ringPath().cgPath
        updateRingDashPattern()
    }
    
    /// Animate the ring.
    @objc private func animate() {
        let elapsedTime = Date().timeIntervalSince(animationStartDate)
        animationTime = elapsedTime * animation.speed
        
        updateRingDashPattern()
        updateGradient()
        
        if softStopAnimation {
            let totalFillLength = ringShapeLayer.lineDashPattern!.enumerated()
                .filter({ $0.offset % 2 == 0 })
                .map({ CGFloat(truncating: $0.element) })
                .reduce(0, +)
            
            if abs(totalFillLength - ringLength()) < 0.01 {
                stopAnimating(soft: false)
            }
        }
    }
    
    /// Reset ring state.
    private func reset() {
        animationStartDate = Date()
        animationTime = 0
        updateRingDashPattern()
        updateGradient()
    }
    
    /// Configure ring appearance.
    private func configureAppearance() {
        gradientLayer.colors = appearance.gradient.colors.map(\.cgColor)
        gradientLayer.locations = appearance.gradient.locations as [NSNumber]
        ringShapeLayer.lineWidth = ringThickness()
        ringShapeLayer.lineCap = animation.segmentsCap
        updateGradient()
        layoutRing()
    }
    
    /// Update the ring dash pattern.
    private func updateRingDashPattern() {
        var dashPattern = [CGFloat]()
        
        for segmentIndex in 0...animation.segmentsCount - 1 {
            let segmentLength = ringLength() / CGFloat(animation.segmentsCount)
            let x = 1 / ringLength() * (segmentLength * CGFloat(segmentIndex))
            let y = self.y(for: x + animationTime)
            let fill: CGFloat = min(1, max(0, y))
            let fillLength = segmentLength * fill
            let emptyLength = segmentLength - fillLength
            
            guard animation.segmentsCap != .butt else {
                dashPattern.append(fillLength)
                dashPattern.append(emptyLength)
                continue
            }
            
            if segmentIndex == 0 {
                dashPattern.append(segmentLength)
                dashPattern.append(0)
            } else if fill == 0 {
                dashPattern[dashPattern.count - 1] += emptyLength
            } else {
                dashPattern.append(fillLength)
                dashPattern.append(emptyLength)
            }
        }
        
        ringShapeLayer.lineCap = animation.segmentsCap
        ringShapeLayer.lineDashPattern = dashPattern as [NSNumber]
        ringShapeLayer.lineDashPhase = animation.isRingRotationEnabled ? animationTime * (ringLength() * 0.25) : 0
    }
    
    /// Update the ring gradient.
    private func updateGradient() {
        let t = animation.isGradientRotationEnabled ? CGFloat(animationTime) + appearance.gradient.angle : appearance.gradient.angle
        gradientLayer.startPoint = .init(x: 0.5 + 0.5 * sin(t), y: 0.5 - 0.5 * cos(t))
        gradientLayer.endPoint = .init(x: 0.5 - 0.5 * sin(t), y: 0.5 + 0.5 * cos(t))
    }
    
    // MARK: Helpers
    
    /// Returns the path of the ring.
    private func ringPath() -> UIBezierPath {
        let angleOffset: CGFloat = -.pi / 2
        return UIBezierPath(
            arcCenter: .init(x: bounds.midX, y: bounds.midY),
            radius: ringRadius(),
            startAngle: .pi * 2 + angleOffset,
            endAngle: angleOffset,
            clockwise: false
        )
    }
    
    /// Returns the length of the ring.
    private func ringLength() -> CGFloat {
        ringRadius() * .pi * 2
    }
    
    /// Returns the radius of the ring.
    private func ringRadius() -> CGFloat {
        min(bounds.width, bounds.height) / 2 - ringThickness() / 2
    }
    
    /// Returns the thickness of the ring.
    private func ringThickness() -> CGFloat {
        switch appearance.ringThickness {
        case .absolute(let value):
            return value
        case .relative(let value):
            return min(bounds.width, bounds.height) / 2 * value
        }
    }
    
    /// Sine function
    private func y(for x: CGFloat) -> CGFloat {
        return (animationCurve.amplitude * sin((x + animationCurve.xOffset) * .pi * 2 * animationCurve.frequency) + 1 + animationCurve.yOffset) / 2
    }
    
}
