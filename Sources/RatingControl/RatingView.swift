//
//  RatingView.swift
//  RatingControl
//
//  Created by Yonat Sharon on 2025-04-05.
//

import SwiftUI

/// SwiftUI wrapper for the RatingControl.
public struct RatingView: UIViewRepresentable {
    @Binding var value: Double
    var maxValue: Int
    @Environment(\.isEnabled) private var isEnabled

    // Configuration properties
    private var emptyImage: UIImage?
    private var filledImage: UIImage?
    private var spacing: CGFloat?
    private var imageSize: CGSize?

    public init(value: Binding<Double>, maxValue: Int = 5) {
        _value = value
        self.maxValue = maxValue
    }

    // For backward compatibility and simpler usage when binding isn't needed
    public init(value: Double, maxValue: Int = 5) {
        _value = .constant(value)
        self.maxValue = maxValue
    }

    public func makeUIView(context: Context) -> RatingControl {
        let ratingControl = RatingControl()
        ratingControl.maxValue = maxValue
        ratingControl.value = value
        ratingControl.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        configureRatingControl(ratingControl)

        return ratingControl
    }

    public func updateUIView(_ uiView: RatingControl, context: Context) {
        uiView.value = value
        uiView.maxValue = maxValue
        uiView.isUserInteractionEnabled = isEnabled
        configureRatingControl(uiView)
    }

    @available(iOS 16.0, *)
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: RatingControl, context: Context) -> CGSize? {
        return proposal.replacingUnspecifiedDimensions(by: uiView.systemLayoutSizeFitting(.zero))
    }

    private func configureRatingControl(_ control: RatingControl) {
        if let emptyImage {
            control.emptyImage = emptyImage
        }

        if let filledImage {
            control.image = filledImage
        }

        if let spacing {
            control.spacing = spacing
        }

        if let imageSize {
            control.imageSize = imageSize
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject {
        var parent: RatingView

        init(_ parent: RatingView) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: RatingControl) {
            parent.value = sender.value
        }
    }
}

// MARK: - Modifiers

public extension RatingView {
    /// Sets the image used for empty (unfilled) parts of the rating.
    func emptyImage(_ image: UIImage) -> RatingView {
        var view = self
        view.emptyImage = image
        return view
    }

    /// Sets the image used for filled parts of the rating.
    func filledImage(_ image: UIImage) -> RatingView {
        var view = self
        view.filledImage = image
        return view
    }

    /// Sets the spacing between rating images.
    func spacing(_ spacing: CGFloat) -> RatingView {
        var view = self
        view.spacing = spacing
        return view
    }

    /// Sets the size for rating images.
    func imageSize(_ size: CGSize) -> RatingView {
        var view = self
        view.imageSize = size
        return view
    }
}

// MARK: - Previews

@available(iOS 17, *)
#Preview {
    @Previewable @State var rating = 2.5

    return ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            Text("Default Rating")
                .font(.headline)
            RatingView(value: $rating)
            Divider()

            Text("Customized Rating - Frozen")
                .font(.headline)
            RatingView(value: 4.5, maxValue: 7)
                .accentColor(.orange)
                .disabled(true)
            Divider()

            Text("Interactive Rating")
                .font(.headline)

            InteractiveRatingView()
            Divider()

            Text("Custom Images")
                .font(.headline)
            RatingView(value: $rating)
                .emptyImage(UIImage(systemName: "heart")!)
                .filledImage(UIImage(systemName: "heart.fill")!)
                .imageSize(CGSize(width: 32, height: 32))
                .accentColor(.red)
            Divider()

            Text("Large Rating")
                .font(.headline)
            let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
            RatingView(value: $rating, maxValue: 5)
                .emptyImage(UIImage(systemName: "star", withConfiguration: config)!)
                .filledImage(UIImage(systemName: "star.fill", withConfiguration: config)!)
                .spacing(10)
        }
        .padding()
    }
}

// Helper view for interactive rating
@available(iOS 17, *)
private struct InteractiveRatingView: View {
    @State private var rating: Double = 3.5

    var body: some View {
        VStack(alignment: .leading) {
            RatingView(value: $rating)

            Text("Current value: \(rating, specifier: "%.1f")")
        }
    }
}
