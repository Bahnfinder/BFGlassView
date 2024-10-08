import UIKit

@IBDesignable
public class CHGlassmorphismView: UIView {
    // MARK: - Properties
    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    private var blurView = UIVisualEffectView()
    private var animatorCompletionValue: CGFloat = 0.65
    private let backgroundView = UIView()
    private let gradientBorderLayer = CAGradientLayer()
    
    public override var backgroundColor: UIColor? {
        get {
            return .clear
        }
        set {}
    }
    
    // MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    deinit {
        animator.stopAnimation(true)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradientBorder()
    }
    
    // MARK: - Public Method
    /// Apply glassmorphism effect to the CHGlassmorphismView
    public func makeGlassmorphismEffect(theme: CHTheme,
                                        density: CGFloat = 0.65,
                                        cornerRadius: CGFloat = 20,
                                        distance: CGFloat = 20) {
        self.setTheme(theme: theme)
        self.setBlurDensity(with: density)
        self.setCornerRadius(cornerRadius)
        self.setDistance(distance)
    }
    
    /// Customizes theme by changing base view's background color.
    /// .light and .dark is available.
    public func setTheme(theme: CHTheme) {
        switch theme {
        case .light:
            self.blurView.effect = nil
            self.blurView.backgroundColor = UIColor.clear
            self.animator.stopAnimation(true)
            self.animator.addAnimations { [weak self] in
                self?.blurView.effect = UIBlurEffect(style: .light)
            }
            self.animator.fractionComplete = animatorCompletionValue
        case .dark:
            self.blurView.effect = nil
            self.blurView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
            self.animator.stopAnimation(true)
            self.animator.addAnimations { [weak self] in
                self?.blurView.effect = UIBlurEffect(style: .dark)
            }
            self.animator.fractionComplete = animatorCompletionValue
        }
    }
    
    /// Customizes blur density of the view.
    /// Value can be set between 0 ~ 1 (default: 0.65)
    /// - parameters:
    ///     - density:  value between 0 ~ 1 (default: 0.65)
    public func setBlurDensity(with density: CGFloat) {
        self.animatorCompletionValue = density
        self.animator.fractionComplete = animatorCompletionValue
    }
    
    /// Changes cornerRadius of the view.
    /// Default value is 20
    public func setCornerRadius(_ value: CGFloat) {
        self.backgroundView.layer.cornerRadius = value
        self.blurView.layer.cornerRadius = value
        self.layer.cornerRadius = value
        self.gradientBorderLayer.cornerRadius = value
    }
    
    /// Change distance of the view.
    /// Value can be set between 0 ~ 100 (default: 20)
    /// - parameters:
    ///     - distance:  value between 0 ~ 100 (default: 20)
    public func setDistance(_ value: CGFloat) {
        let distance = min(max(value, 0), 100)
        self.backgroundView.layer.shadowRadius = distance
    }
    
    // MARK: - Private Method
    private func initialize() {
        // Setup backgroundView
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowRadius = 20.0
        backgroundView.layer.shouldRasterize = true
        backgroundView.layer.rasterizationScale = UIScreen.main.scale
        
        // Setup blurView
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 20
        blurView.backgroundColor = UIColor.clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.insertSubview(blurView, at: 0)
        
        // Constraints
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
        ])
        
        // Animator setup
        animator.addAnimations { [weak self] in
            self?.blurView.effect = UIBlurEffect(style: .light)
        }
        animator.fractionComplete = animatorCompletionValue // default value is 0.65
        
        // Setup gradient border
        setupGradientBorder()
    }
    
    private func setupGradientBorder() {
        gradientBorderLayer.colors = [
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor
        ]
        gradientBorderLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientBorderLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientBorderLayer.frame = self.bounds
        gradientBorderLayer.cornerRadius = self.layer.cornerRadius
        gradientBorderLayer.masksToBounds = true
        gradientBorderLayer.borderWidth = 1
        gradientBorderLayer.borderColor = UIColor.clear.cgColor
        gradientBorderLayer.type = .axial
        
        // Create a shape layer that defines the path for the border
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = gradientBorderLayer.borderWidth
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientBorderLayer.mask = shapeLayer
        
        self.layer.addSublayer(gradientBorderLayer)
    }
    
    private func updateGradientBorder() {
        gradientBorderLayer.frame = self.bounds
        gradientBorderLayer.cornerRadius = self.layer.cornerRadius
        
        if let shapeLayer = gradientBorderLayer.mask as? CAShapeLayer {
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        }
    }
    
    // MARK: - Theme
    public enum CHTheme {
        case light
        case dark
    }
}
