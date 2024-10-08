import UIKit

@IBDesignable
public class CHGlassmorphismView: UIView {
    // MARK: - Properties
    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private var borderGradientLayer = CAGradientLayer()
    private var borderShapeLayer = CAShapeLayer()

    public override var backgroundColor: UIColor? {
        get {
            return .clear
        }
        set {}
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }
    
    // MARK: - Private Methods
    private func initialize() {
        // Set up the blur view for glassmorphism effect
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        
        // Constraints for blur view
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        // Border setup
        setupBorder()
        
        // Add subtle shadow to mimic depth
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 15
    }
    
    private func setupBorder() {
        // Gradient border mimicking VisionOS style, brighter at corners
        borderGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        borderGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        borderGradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.6).cgColor, // Top-left corner
            UIColor.white.withAlphaComponent(0.1).cgColor, // Center (subtle)
            UIColor.white.withAlphaComponent(0.6).cgColor  // Bottom-right corner
        ]
        borderGradientLayer.locations = [0, 0.5, 1]
        borderGradientLayer.frame = bounds
        borderGradientLayer.cornerRadius = 20
        
        // Shape layer to define the path of the border
        borderShapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), cornerRadius: 20)
        borderShapeLayer.path = path.cgPath
        borderShapeLayer.fillColor = UIColor.clear.cgColor
        borderShapeLayer.strokeColor = UIColor.white.cgColor // The stroke color will not be directly visible because the gradient mask will define the color.
        borderShapeLayer.lineWidth = 1.5
        borderShapeLayer.cornerRadius = 20
        
        // Apply the gradient as the mask of the shape layer to give the "glassy" border effect
        borderGradientLayer.mask = borderShapeLayer
        layer.addSublayer(borderGradientLayer)
    }
    
    private func updateBorder() {
        // Update the gradient border frame and corner radius on layout changes
        borderGradientLayer.frame = bounds
        borderShapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), cornerRadius: 20).cgPath
    }
}
