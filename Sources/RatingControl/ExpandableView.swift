//
//  ExpandableView.swift
//  RatingControl
//
//  Created by Yonat Sharon on 2025-04-19.
//

import UIKit

/// A view that can expand and collapse its content with animation, similar to SwiftUI's DisclosureGroup.
@IBDesignable
public class ExpandableView: UIStackView {
    /// The header view that is always visible and can be tapped to toggle expansion
    public var headerView: UIView = .init() {
        didSet {
            oldValue.removeFromSuperview()
            addHeaderView()
        }
    }

    /// The content view that is shown when expanded and hidden when collapsed
    public var contentView: UIView = .init() {
        didSet {
            oldValue.removeFromSuperview()
            addContentView()
        }
    }

    /// Whether the view is currently expanded
    @IBInspectable public var isExpanded: Bool = false {
        didSet {
            if oldValue != isExpanded {
                updateExpandedState(animated: true)
            }
        }
    }

    /// Image to show when the view is collapsed, defaults to chevron.down
    public var expandImage: UIImage? {
        get { indicatorImageView.image }
        set { indicatorImageView.image = newValue }
    }

    private let indicatorImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
    private let headerContainerView = UIView()
    private let contentContainerView = UIView()

    public convenience init(headerView: UIView, contentView: UIView) {
        self.init(frame: .zero)
        self.headerView = headerView
        self.contentView = contentView
        addHeaderView()
        addContentView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension ExpandableView {
    func setup() {
        axis = .vertical
        addArrangedSubview(headerContainerView)
        addArrangedSubview(contentContainerView)

        setupIndicator()
        setupTapGesture()
        updateExpandedState(animated: false)
    }

    func setupIndicator() {
        indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        indicatorImageView.contentMode = .scaleAspectFit
        headerContainerView.addSubview(indicatorImageView)
        NSLayoutConstraint.activate([
            indicatorImageView.trailingAnchor.constraint(equalTo: headerContainerView.layoutMarginsGuide.trailingAnchor),
            indicatorImageView.centerYAnchor.constraint(equalTo: headerContainerView.centerYAnchor),
            indicatorImageView.heightAnchor.constraint(lessThanOrEqualTo: headerContainerView.heightAnchor),
        ])
    }

    func addHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: headerContainerView.layoutMarginsGuide.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: headerContainerView.layoutMarginsGuide.bottomAnchor),
            headerView.leadingAnchor.constraint(equalTo: headerContainerView.layoutMarginsGuide.leadingAnchor),
            indicatorImageView.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: headerView.trailingAnchor, multiplier: 1.0),
        ])
    }

    func addContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.bottomAnchor),
        ])
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        headerContainerView.addGestureRecognizer(tapGesture)
    }

    @objc func headerTapped() {
        isExpanded.toggle()
    }

    func updateExpandedState(animated: Bool) {
        if animated {
            contentContainerView.alpha = 0
            UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
                guard let self else { return }
                contentContainerView.isHidden = !isExpanded
                contentContainerView.alpha = isExpanded ? 1 : 0
            }
        } else {
            contentContainerView.isHidden = !isExpanded
            contentContainerView.alpha = isExpanded ? 1 : 0
        }

        updateIndicatorImage(animated: animated)
    }

    func updateIndicatorImage(animated: Bool = false) {
        let targetAngle: CGFloat = isExpanded ? .pi : 0
        if animated {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = .pi - targetAngle
            rotationAnimation.toValue = targetAngle
            indicatorImageView.layer.add(rotationAnimation, forKey: "rotation")
        }
        indicatorImageView.transform = CGAffineTransform(rotationAngle: targetAngle)
    }
}

@available(iOS 17, *)
#Preview {
    let headerLabel = UILabel()
    headerLabel.text = "Expandable Section"
    headerLabel.font = .boldSystemFont(ofSize: 18)
    headerLabel.textAlignment = .left
    headerLabel.backgroundColor = .cyan

    let contentLabel = UILabel()
    contentLabel.text = "This is the content that can be expanded and collapsed. Tap the header to toggle."
    contentLabel.numberOfLines = 0
    contentLabel.backgroundColor = .green

    let expandableView = ExpandableView(headerView: headerLabel, contentView: contentLabel)
    expandableView.isExpanded = true
    expandableView.backgroundColor = .systemGray3

    return expandableView
}
