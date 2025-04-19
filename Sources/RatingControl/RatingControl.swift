//
//  RatingControl.swift
//  RatingControl
//
//  Created by Yonat Sharon on 2025-04-05.
//

import UIKit

/// A control that displays a rating as a row of images and allows the user to edit it.
@IBDesignable
public class RatingControl: UIControl {
    /// Maximum rating value, default is 5
    @IBInspectable public var maxValue: Int = 5 {
        didSet {
            if maxValue < 1 {
                maxValue = 1
            }
            setupImageViews()
            setupValueCrop()
            updateConstraints()
        }
    }

    /// Current rating value, can be a decimal number between 0 and maxValue, default is 0
    @IBInspectable public var value: Double = 0 {
        didSet {
            value = max(0, min(Double(maxValue), value))
            if value != oldValue {
                setupValueCrop()
            }
        }
    }

    /// Image to show for empty part of the rating, default is "star" system image
    public var emptyImage: UIImage = .init(systemName: "star")! {
        didSet {
            for imageView in stackView.arrangedSubviews as? [UIImageView] ?? [] {
                imageView.image = emptyImage
            }
        }
    }

    /// Image to show for filled part of the rating, default is "star.fill" system image
    public var image: UIImage = .init(systemName: "star.fill")! {
        didSet {
            for imageView in filledStackView.arrangedSubviews as? [UIImageView] ?? [] {
                imageView.image = image
            }
            setupImageSize()
        }
    }

    /// Spacing between images, default is 4
    @IBInspectable public var spacing: CGFloat = 4 {
        didSet {
            stackView.spacing = spacing
            filledStackView.spacing = spacing
            updateConstraints()
        }
    }

    /// Size of the rating images, default is nil which uses the image's size
    public var imageSize: CGSize? {
        didSet {
            setupImageSize()
        }
    }

    // MARK: - Overrides

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public func tintColorDidChange() {
        super.tintColorDidChange()
        for subview in stackView.arrangedSubviews + filledStackView.arrangedSubviews {
            subview.tintColor = tintColor
        }
    }

    override public func updateConstraints() {
        widthConstraint?.constant = effectiveWidth
        heightConstraint?.constant = currentImageSize.height

        super.updateConstraints()
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        value = 2.5
    }

    // MARK: - Private Properties

    private let stackView = UIStackView.centeredFillEqual()
    private let filledStackView = UIStackView.centeredFillEqual()
    private let valueCropView = UIView()
    private var valueCropConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var currentImageSize: CGSize = .zero

    // Total width of all stars and spacing between them
    private var effectiveWidth: CGFloat {
        return CGFloat(maxValue) * currentImageSize.width + CGFloat(maxValue - 1) * spacing
    }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)

        stackView.spacing = spacing
        addSubview(stackView)
        stackView.constrain(to: self)

        valueCropView.clipsToBounds = true
        addSubview(valueCropView)
        valueCropView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueCropView.topAnchor.constraint(equalTo: topAnchor),
            valueCropView.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueCropView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        filledStackView.spacing = spacing
        valueCropView.addSubview(filledStackView)
        filledStackView.constrain(to: stackView)

        widthConstraint = widthAnchor.constraint(equalToConstant: 0)
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        if let widthConstraint = widthConstraint, let heightConstraint = heightConstraint {
            NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        }

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesture)))

        setupImageSize()
        setupImageViews()
        setupValueCrop()
    }

    private func setupImageViews() {
        stackView.removeAllArrangedSubviewsFromSuperview()
        filledStackView.removeAllArrangedSubviewsFromSuperview()

        for _ in 0 ..< maxValue {
            stackView.addArrangedImageView(image: emptyImage, imageSize: currentImageSize, tintColor: tintColor)
            filledStackView.addArrangedImageView(image: image, imageSize: currentImageSize, tintColor: tintColor)
        }
    }

    private func setupImageSize() {
        currentImageSize = imageSize ?? image.size

        let imageViews = stackView.arrangedSubviews + filledStackView.arrangedSubviews
        for imageView in imageViews {
            for constraint in imageView.constraints {
                if constraint.firstAttribute == .width {
                    constraint.constant = currentImageSize.width
                } else if constraint.firstAttribute == .height {
                    constraint.constant = currentImageSize.height
                }
            }
        }

        updateConstraints()
    }

    private func setupValueCrop() {
        valueCropConstraint?.isActive = false
        valueCropConstraint = valueCropView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: value / Double(maxValue))
        valueCropConstraint!.isActive = true
    }

    // MARK: - User Interaction

    @objc private func handleGesture(_ gesture: UIGestureRecognizer) {
        let location = gesture.location(in: self)
        let itemWidth = effectiveWidth / CGFloat(maxValue) // bound.width may be incorrect when the control is inside a wider container like a VStack

        var newValue = Double(location.x / itemWidth).rounded()
        newValue = max(0, min(Double(maxValue), newValue))

        if newValue != value {
            value = newValue
            sendActions(for: .valueChanged)
        }
    }
}

// MARK: - Helpers

extension UIStackView {
    static func centeredFillEqual() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }

    func removeAllArrangedSubviewsFromSuperview() {
        for arrangedSubview in arrangedSubviews {
            removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }

    func addArrangedImageView(image: UIImage, imageSize: CGSize, tintColor: UIColor) {
        let imageView = UIImageView(image: image)
        imageView.tintColor = tintColor
        imageView.contentMode = .scaleAspectFit
        addArrangedSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: imageSize.height),
        ])
    }
}

extension UIView {
    func constrain(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
