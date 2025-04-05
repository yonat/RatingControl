//
//  RatingViewController.swift
//  RatingControlDemo
//
//  Created by Yonat Sharon on 2025-04-05.
//

import RatingControl
import SwiftUI
import UIKit

class RatingViewController: UIViewController {
    private var currentRating: Double = 3.5
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])

        addDefaultRatingControl()
        addCustomizedRatingControl()
        addInteractiveRatingControl()
        addCustomImageRatingControl()
        addLargeRatingControl()
    }

    // MARK: - Rating Controls

    private func addDefaultRatingControl() {
        let titleLabel = createTitleLabel("Default Rating Control")
        stackView.addArrangedSubview(titleLabel)

        let ratingControl = RatingControl()
        ratingControl.value = 3
        stackView.addArrangedSubview(ratingControl)

        addSeparator()
    }

    private func addCustomizedRatingControl() {
        let titleLabel = createTitleLabel("Customized Rating Control - Frozen")
        stackView.addArrangedSubview(titleLabel)

        let ratingControl = RatingControl()
        ratingControl.maxValue = 7
        ratingControl.value = 4.5
        ratingControl.spacing = 8
        ratingControl.isUserInteractionEnabled = false
        ratingControl.tintColor = .systemOrange
        stackView.addArrangedSubview(ratingControl)

        addSeparator()
    }

    private func addInteractiveRatingControl() {
        let titleLabel = createTitleLabel("Interactive Rating Control")
        stackView.addArrangedSubview(titleLabel)

        let ratingControl = RatingControl()
        ratingControl.value = currentRating
        ratingControl.addTarget(self, action: #selector(ratingChanged(_:)), for: .valueChanged)
        stackView.addArrangedSubview(ratingControl)

        let valueLabel = UILabel()
        valueLabel.text = "Current value: \(currentRating)"
        valueLabel.tag = 100 // Tag for identification
        valueLabel.textAlignment = .center
        valueLabel.font = .systemFont(ofSize: 14)
        stackView.addArrangedSubview(valueLabel)

        addSeparator()
    }

    private func addCustomImageRatingControl() {
        let titleLabel = createTitleLabel("Custom Images")
        stackView.addArrangedSubview(titleLabel)

        let ratingControl = RatingControl()
        ratingControl.emptyImage = UIImage(systemName: "heart")!
        ratingControl.image = UIImage(systemName: "heart.fill")!
        ratingControl.value = 4
        ratingControl.tintColor = .systemRed
        ratingControl.imageSize = CGSize(width: 32, height: 32)
        stackView.addArrangedSubview(ratingControl)

        addSeparator()
    }

    private func addLargeRatingControl() {
        let titleLabel = createTitleLabel("Large Rating Control")
        stackView.addArrangedSubview(titleLabel)

        let ratingControl = RatingControl()

        // Create larger images
        let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        ratingControl.emptyImage = UIImage(systemName: "star", withConfiguration: config)!
        ratingControl.image = UIImage(systemName: "star.fill", withConfiguration: config)!
        ratingControl.value = 3.5
        ratingControl.maxValue = 5
        ratingControl.spacing = 10
        stackView.addArrangedSubview(ratingControl)
    }

    // MARK: - Helper Methods

    private func createTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }

    private func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(separator)

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func ratingChanged(_ sender: RatingControl) {
        currentRating = sender.value
        if let valueLabel = stackView.arrangedSubviews.first(where: { $0.tag == 100 }) as? UILabel {
            valueLabel.text = "Current value: \(currentRating)"
        }
    }
}

@available(iOS 17, *)
#Preview {
    RatingViewController()
}
