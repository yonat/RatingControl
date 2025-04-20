//
//  ThickProgressView.swift
//  RatingControl
//
//  Created by Yonat Sharon on 2025-04-17.
//

import UIKit

/// A progress view with fully rounded corners for any thickness
@IBDesignable
public class ThickProgressView: UIView {
    @IBInspectable public var thickness: CGFloat = 8 {
        didSet {
            updateThickness()
        }
    }

    /// Progress value between 0.0 and 1.0
    @IBInspectable public var progress: CGFloat {
        get { progressValue }
        set { setProgress(newValue, animated: false) }
    }

    public func setProgress(_ progress: CGFloat, animated: Bool) {
        progressValue = min(max(progress, 0), 1)
        updateProgress(animated: animated)
    }

    public convenience init(thickness: CGFloat, progress: CGFloat? = nil) {
        self.init()
        self.thickness = thickness
        updateThickness()
        if let progress {
            self.progress = progress
            updateProgress()
        }
    }

    private var progressValue: CGFloat = 0
    private let progressView = UIView()
    private var progressWidthConstraint: NSLayoutConstraint?
    private lazy var heightConstraint: NSLayoutConstraint = {
        let this = heightAnchor.constraint(equalToConstant: thickness)
        this.isActive = true
        return this
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public func tintColorDidChange() {
        super.tintColorDidChange()
        progressView.backgroundColor = tintColor
    }
}

private extension ThickProgressView {
    func setup() {
        setupColors()
        setupConstraints()
        updateThickness()
        updateProgress()
    }

    func setupColors() {
        backgroundColor = .tertiarySystemFill
        progressView.backgroundColor = tintColor
    }

    func setupConstraints() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func updateThickness() {
        heightConstraint.constant = thickness
        let cornerRadius = thickness / 2
        layer.cornerRadius = cornerRadius
        progressView.layer.cornerRadius = cornerRadius
    }

    func updateProgress(animated: Bool = false) {
        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: progressValue)
        progressWidthConstraint?.isActive = true
        if animated {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                self.layoutIfNeeded()
            }
        }
    }
}

@available(iOS 17, *)
#Preview {
    let progressView = ThickProgressView(thickness: 32, progress: 0.25)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        progressView.setProgress(0.75, animated: true)
    }
    return progressView
}
