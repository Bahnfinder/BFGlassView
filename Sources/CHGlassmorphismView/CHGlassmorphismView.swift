import UIKit

@IBDesignable
public class CHGlassmorphismView: UIView {
    // MARK: - Properties
    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    private var blurView = UIVisualEffectView()
    private var animatorCompletionValue: CGFloat = 0.65
    private let backgroundView = UIView()
    private let gradientLayer = CAGradientLayer()
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
        animator.pauseAnimation()
        animator.stopAnimation(true)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
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
        self.applyGradientBorder()
    }
    
    /// Customizes theme by changing base view's background color.
    /// .light and .dark is available.
    public func setTheme(theme: CHTheme) {
        switch theme {
        case .light:
            self.blurView.effect = nil
            self.blurView.backgroundColor = UIColor.clear
            self.animator.stopAnimation(true)
            self.animator.addAnimations {
                self.blurView.effect = UIBlurEffect(style: .light)
            }
            self.animator.fractionComplete = animatorCompletionValue
            self.layer.borderColor = UIColor.clear.cgColor
        case .dark:
            self.blurView.effect = nil
            self.blurView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
            self.animator.stopAnimation(true)
            self.animator.addAnimations {
                self.blurView.effect = UIBlurEffect(style: .dark)
            }
            self.animator.fractionComplete = animatorCompletionValue
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    /// Customizes blur density of the view.
    /// Value can be set between 0 ~ 1 (default: 0.65)
    public func setBlurDensity(with density: CGFloat) {
        self.animatorCompletionValue = density
        self.animator.fractionComplete = animatorCompletionValue
    }
    
    /// Changes cornerRadius of the view.
    /// Default value is 20
    public func setCornerRadius(_ value: CGFloat) {
        self.backgroundView.layer.cornerRadius = value
        self.blurView.layer.cornerRadius = value
        self.gradientLayer.cornerRadius = value
    }
    
    /// Change distance of the view.
    /// Value can be set between 0 ~ 100 (default: 20)
    public func setDistance(_ value: CGFloat) {
        var distance = value
        if value < 0 {
            distance = 0
        } else if value > 100 {
            distance = 100
        }
        self.backgroundView.layer.shadowRadius = distance
    }
    
    // MARK: - Private Method
    private func initialize() {
        // backgoundView(baseView) setting
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowRadius = 20.0
        
        // blurEffectView setting
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 20
        blurView.backgroundColor = UIColor.clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: self.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        
        // add gradient border for glassmorphism
        applyGradientBorder()
        
        // add animation for managing density
        animator.addAnimations {
            self.blurView.effect = UIBlurEffect(style: .light)
        }
        animator.fractionComplete = animatorCompletionValue // default value is 0.65
    }
    
    private func applyGradientBorder() {
        gradientLayer.frame = backgroundView.bounds
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.8).cgColor, // Bright top-left
            UIColor.white.withAlphaComponent(0.3).cgColor, // Faded middle
            UIColor.white.withAlphaComponent(0.5).cgColor  // Brighter bottom-right
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = backgroundView.layer.cornerRadius
        gradientLayer.masksToBounds = true
        gradientLayer.borderWidth = 1.5
        
        if gradientLayer.superlayer == nil {
            backgroundView.layer.addSublayer(gradientLayer)
        }
    }
    
    // MARK: - Theme
    public enum CHTheme {
        case light
        case dark
    }
}
