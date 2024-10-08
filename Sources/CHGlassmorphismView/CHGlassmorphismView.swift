import UIKit

@IBDesignable
public class CHGlassmorphismView: UIView {
    // MARK: - Properties
    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    private var blurView = UIVisualEffectView()
    private var animatorCompletionValue: CGFloat = 0.65
    private let backgroundView = UIView()
    private var borderGradientLayer = CAGradientLayer()
    private var borderShapeLayer = CAShapeLayer()
    
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
        animator.finishAnimation(at: .current)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }
    
    // MARK: - Public Methods
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
    /// .light and .dark are available.
    public func setTheme(theme: CHTheme) {
        switch theme {
        case .light:
            self.blurView.effect = nil
            self.blurView.backgroundColor = UIColor.clear
            animator.stopAnimation(true)
            animator.addAnimations { [weak self] in
                self?.blurView.effect = UIBlurEffect(style: .light)
            }
            animator.fractionComplete = animatorCompletionValue
            updateBorderColors(theme: .light)
        case .dark:
            self.blurView.effect = nil
            self.blurView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
            animator.stopAnimation(true)
            animator.addAnimations { [weak self] in
                self?.blurView.effect = UIBlurEffect(style: .dark)
            }
            animator.fractionComplete = animatorCompletionValue
            updateBorderColors(theme: .dark)
        }
    }
    
    /// Customizes blur density of the view.
    /// Value can be set between 0 ~ 1 (default: 0.65)
    public func setBlurDensity(with density: CGFloat) {
        animatorCompletionValue = density
        animator.fractionComplete = animatorCompletionValue
    }
    
    /// Changes cornerRadius of the view.
    /// Default value is 20
    public func setCornerRadius(_ value: CGFloat) {
        backgroundView.layer.cornerRadius = value
        blurView.layer.cornerRadius = value
        borderShapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderShapeLayer.lineWidth / 2, dy: borderShapeLayer.lineWidth / 2), cornerRadius: value).cgPath
        borderGradientLayer.cornerRadius = value
    }
    
    /// Change distance of the view.
    /// Value can be set between 0 ~ 100 (default: 20)
    public func setDistance(_ value: CGFloat) {
        let distance = max(0, min(value, 100))
        if value != distance {
            print("Warning: Distance value adjusted to be within 0 to 100.")
        }
        backgroundView.layer.shadowRadius = distance
    }
    
    // MARK: - Private Methods
    private func initialize() {
        // Background view setup
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(backgroundView, at: 0)
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowRadius = 20.0
        backgroundView.layer.shouldRasterize = true
        backgroundView.layer.rasterizationScale = UIScreen.main.scale
        
        // Blur effect view setup
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 20
        blurView.backgroundColor = UIColor.clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.insertSubview(blurView, at: 0)
        
        // Constraints
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
        
        // Border setup
        setupBorder()
    }
    
    private func setupBorder() {
        borderGradientLayer = CAGradientLayer()
        borderGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        borderGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        borderGradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor
        ]
        borderGradientLayer.locations = [0, 0.5, 1]
        borderGradientLayer.frame = bounds
        borderGradientLayer.cornerRadius = backgroundView.layer.cornerRadius
        
        borderShapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: backgroundView.layer.cornerRadius)
        borderShapeLayer.path = path.cgPath
        borderShapeLayer.fillColor = UIColor.clear.cgColor
        borderShapeLayer.strokeColor = UIColor.black.cgColor // Placeholder color
        borderShapeLayer.lineWidth = 1
        borderShapeLayer.cornerRadius = backgroundView.layer.cornerRadius
        
        borderGradientLayer.mask = borderShapeLayer
        layer.addSublayer(borderGradientLayer)
    }
    
    private func updateBorder() {
        // Update frames
        borderGradientLayer.frame = bounds
        borderGradientLayer.cornerRadius = backgroundView.layer.cornerRadius
        
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderShapeLayer.lineWidth / 2, dy: borderShapeLayer.lineWidth / 2), cornerRadius: backgroundView.layer.cornerRadius)
        borderShapeLayer.path = path.cgPath
        borderShapeLayer.lineWidth = 1
    }
    
    private func updateBorderColors(theme: CHTheme) {
        switch theme {
        case .light:
            borderGradientLayer.colors = [
                UIColor.white.withAlphaComponent(0.8).cgColor,
                UIColor.white.withAlphaComponent(0.2).cgColor,
                UIColor.white.withAlphaComponent(0.8).cgColor
            ]
        case .dark:
            borderGradientLayer.colors = [
                UIColor.white.withAlphaComponent(0.5).cgColor,
                UIColor.white.withAlphaComponent(0.1).cgColor,
                UIColor.white.withAlphaComponent(0.5).cgColor
            ]
        }
    }
    
    // MARK: - Theme
    public enum CHTheme {
        case light
        case dark
    }
}
