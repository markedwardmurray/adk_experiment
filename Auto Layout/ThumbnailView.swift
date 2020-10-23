//
//  ThumbnailView.swift
//  Sample
//
//  Created by Zev Eisenberg on 9/4/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

final class ThumbnailView: UIView {

  private let textView = UITextView().configure {
    $0.isUserInteractionEnabled = false
    $0.isScrollEnabled = false
    $0.setContentCompressionResistancePriority(.required, for: .vertical)
    $0.textContainerInset = .zero
    $0.textContainer.lineFragmentPadding = 0
  }

  private let imageView = UIImageView(image: UIImage(named: "thumbnail.jpg"))

  private let footerView = FooterView()

  private let thumbnailSize = CGSize(width: 75.0, height: 75.0)

  private let stackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .backgroundColor

    stackView.addArrangedSubviews([textView, footerView])
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 5
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: .inset, bottom: 0, right: .inset)

    addSubview(stackView)
    addSubview(imageView)

    stackView.pinEdges(to: self)
    imageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: textView.textContainerInset.top),
      imageView.bottomAnchor.constraint(lessThanOrEqualTo: textView.bottomAnchor).withPriority(.required - 1),
      imageView.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
      imageView.widthAnchor.constraint(equalToConstant: thumbnailSize.width),
      imageView.heightAnchor.constraint(equalToConstant: thumbnailSize.height)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
    updateExclusionPaths(targetWidth: targetSize.width)
    
    let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)

    return size
  }

  override func layoutSubviews() {
    updateExclusionPaths(targetWidth: bounds.width)
    super.layoutSubviews()
  }

  func set(headline: String, summary: String) {
    let string = NSMutableAttributedString(
      string: headline + "\n",
      attributes: [
        .font: UIFont.boldSystemFont(ofSize: 18),
        .foregroundColor: UIColor.headlineText
      ]
    )

    let summary = NSAttributedString(
      string: summary,
      attributes: [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.bodyText
      ]
    )

    string.append(summary)

    textView.attributedText = string
  }

  private func updateExclusionPaths(targetWidth: CGFloat) {
    let margin: CGFloat = 5
    let rect = CGRect(
      x: targetWidth - stackView.layoutMargins.left - stackView.layoutMargins.right - thumbnailSize.width - margin - textView.textContainerInset.left - textView.textContainerInset.right,
      y: 0,
      width: thumbnailSize.width + margin + textView.textContainerInset.left + textView.textContainerInset.right,
      height: thumbnailSize.height + margin
    )
    let exclusionPath = UIBezierPath(rect: rect)
    textView.textContainer.exclusionPaths = [exclusionPath]
  }
}
