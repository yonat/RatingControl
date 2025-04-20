//
//  RatingSummaryView.swift
//  RatingControl
//
//  Created by Yonat Sharon on 2025-04-17.
//

import UIKit

/// A view that displays a summary of ratings as a list of labels with counts and percentage bars.
@IBDesignable
public class RatingSummaryView: UIView {
    /// Array of strings that describe the different ratings (e.g., ["Excellent", "Very Good", "Average", "Poor", "Terrible"])
    public var titles: [String] = [] {
        didSet {
            if oldValue.count == titles.count {
                for (index, title) in titles.enumerated() {
                    detailRow(index: index)?.titleLabel.text = title
                }
            } else {
                headerView.ratingControl.maxValue = titles.count
                setupDetailRows()
                updateCounts()
            }
        }
    }

    /// Dictionary mapping rating values to counts (e.g., [5: 20, 4: 1, 3: 0, 2: 1, 1: 0])
    public var counts: [Int: Int] = [:] {
        didSet {
            updateCounts()
        }
    }

    /// Image to show for each rating, default is "star.fill" system image
    public var image: UIImage {
        get { headerView.ratingControl.image }
        set { headerView.ratingControl.image = newValue }
    }

    /// Image to show for empty part of the rating, default is "star" system image
    public var emptyImage: UIImage {
        get { headerView.ratingControl.emptyImage }
        set { headerView.ratingControl.emptyImage = newValue }
    }

    /// Size of the rating images, default is nil which uses the image's size
    public var imageSize: CGSize? {
        get { headerView.ratingControl.imageSize }
        set { headerView.ratingControl.imageSize = newValue }
    }

    /// Whether the rating rows are expanded (visible) or collapsed (hidden)
    public var isExpanded: Bool {
        get { expandableView.isExpanded }
        set { expandableView.isExpanded = newValue }
    }

    private let expandableView = ExpandableView()
    private let headerView = RatingTotalView(spacing: Metrics.headerInternalSpacing)
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metrics.rowSpacing
        stackView.alignment = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension RatingSummaryView {
    enum Metrics {
        static let rowSpacing: CGFloat = 12
        static let headerSpacing: CGFloat = 18
        static let headerInternalSpacing: CGFloat = 10
        static let detailProgressThickness: CGFloat = 10
        static let averageRatingFont = UIFont.boldSystemFont(ofSize: 24)
        static let ratingsCountFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let detailTitleFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        static let detailPercentageFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        static let ratingsCountString = "Ratings"

        static let ratingFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            formatter.minimumFractionDigits = 1
            return formatter
        }()
    }

    func setup() {
        expandableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(expandableView)
        NSLayoutConstraint.activate([
            expandableView.topAnchor.constraint(equalTo: topAnchor),
            expandableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            expandableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        headerView.ratingLabel.font = Metrics.averageRatingFont
        headerView.ratingsCountLabel.font = Metrics.ratingsCountFont

        expandableView.headerView = headerView
        expandableView.contentView = detailsStackView
    }

    func setupDetailRows() {
        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for title in titles {
            let ratingRow = RatingDetailRow(title: title)
            ratingRow.progressView.thickness = Metrics.detailProgressThickness
            ratingRow.titleLabel.font = Metrics.detailTitleFont
            ratingRow.percentageLabel.font = Metrics.detailPercentageFont

            detailsStackView.addArrangedSubview(ratingRow)
            NSLayoutConstraint.activate([
                ratingRow.progressView.leadingAnchor.constraint(equalTo: headerView.ratingLabel.leadingAnchor),
                ratingRow.progressView.trailingAnchor.constraint(equalTo: headerView.ratingsCountLabel.leadingAnchor),
            ])
        }
    }

    func updateCounts() {
        var totalCount = 0
        var weightedSum = 0
        for (rating, count) in counts {
            if rating > titles.count {
                continue
            }
            totalCount += count
            weightedSum += rating * count
        }
        let averageRating = totalCount > 0 ? Double(weightedSum) / Double(totalCount) : 0

        // Update header
        headerView.ratingLabel.text = Metrics.ratingFormatter.string(from: NSNumber(value: averageRating)) ?? String(format: "%.1f", averageRating)
        headerView.ratingsCountLabel.text = "\(totalCount) \(Metrics.ratingsCountString)"
        headerView.ratingControl.value = averageRating

        // Update rating rows
        let detailsCount = detailsStackView.arrangedSubviews.count
        for i in 0 ..< detailsCount {
            detailRow(index: i)?.percentage = totalCount > 0 ? Double(counts[detailsCount - i] ?? 0) / Double(totalCount) : 0
        }
    }

    func detailRow(index: Int) -> RatingDetailRow? {
        guard index < detailsStackView.arrangedSubviews.count else { return nil }
        return detailsStackView.arrangedSubviews[index] as? RatingDetailRow
    }
}

private class RatingTotalView: UIView {
    let ratingControl = RatingControl()
    let ratingLabel = UILabel()
    let ratingsCountLabel = UILabel()

    init(spacing: CGFloat) {
        super.init(frame: .zero)
        setup(spacing: spacing)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(spacing: CGFloat) {
        ratingControl.isUserInteractionEnabled = false
        ratingControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingControl)

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingLabel)

        ratingsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingsCountLabel)

        NSLayoutConstraint.activate([
            ratingControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingControl.centerYAnchor.constraint(equalTo: centerYAnchor),

            ratingLabel.leadingAnchor.constraint(equalTo: ratingControl.trailingAnchor, constant: spacing),
            ratingLabel.topAnchor.constraint(equalTo: topAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            ratingsCountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: ratingLabel.trailingAnchor, constant: spacing),
            ratingsCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            ratingsCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

private class RatingDetailRow: UIStackView {
    let titleLabel = UILabel()
    let progressView = ThickProgressView()
    let percentageLabel = UILabel()

    var percentage: Double = 0 {
        didSet {
            progressView.progress = CGFloat(percentage)
            percentageLabel.text = "\(Int((percentage * 100).rounded()))%"
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setup()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        alignment = .center
        percentageLabel.textAlignment = .right

        addArrangedSubview(titleLabel)
        addArrangedSubview(progressView)
        addArrangedSubview(percentageLabel)
    }
}

@available(iOS 17, *)
#Preview {
    let ratingSummaryView = RatingSummaryView()
    ratingSummaryView.titles = ["Excellent", "Very Good", "Average", "Poor", "Terrible"]
    ratingSummaryView.counts = [5: 20, 4: 1, 3: 0, 2: 1, 1: 0]

    let container = UIView()
    container.addSubview(ratingSummaryView)
    ratingSummaryView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        ratingSummaryView.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
        ratingSummaryView.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
        ratingSummaryView.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
        ratingSummaryView.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor),
    ])

    container.backgroundColor = .lightGray
    ratingSummaryView.backgroundColor = .white

    return container
}
