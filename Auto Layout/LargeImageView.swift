//
//  LargeImageView.swift
//  Sample
//
//  Created by Su, Wei-Lun on 9/8/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

final class LargeImageView: UIView {

  private let headlineLabel = UILabel().configure {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.setContentHuggingPriority(.required, for: .vertical)
  }

  private let summaryLabel = UILabel().configure {
    $0.numberOfLines = 0
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setContentHuggingPriority(.required, for: .vertical)
    $0.setContentCompressionResistancePriority(.defaultHigh - 1, for: .vertical)
  }

  private let kickerLabel = UILabel().configure {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setContentHuggingPriority(.required, for: .vertical)
    $0.setContentCompressionResistancePriority(.required, for: .vertical)
  }

  private let creditLabel = UILabel().configure {
    $0.setContentHuggingPriority(.required, for: .vertical)
    $0.setContentCompressionResistancePriority(.required, for: .vertical)
  }

  private let footerView = FooterView()

  private let imageView = UIImageView().configure {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setContentHuggingPriority(.defaultLow - 1, for: .vertical) // lower than labels
  }

  private var imageAspectConstraint = NSLayoutConstraint()

  override init(frame: CGRect) {
    super.init(frame: frame)

    let mainStack = UIStackView(axis: .vertical, spacing: 10, arrangedSubviews: [
      UIStackView(axis: .vertical, spacing: 2, arrangedSubviews: [
        imageView,
        creditLabel
      ]),
      UIStackView(axis: .vertical, spacing: 2, arrangedSubviews: [
        kickerLabel,
        headlineLabel
      ]),
      summaryLabel,
      footerView,
    ])
    addSubview(mainStack)
    mainStack.pinEdgesToSuperView(lowerBottomAndTrailingPriorities: true)
    mainStack.isLayoutMarginsRelativeArrangement = true
    mainStack.layoutMargins = UIEdgeInsets(all: 10)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(headline: String, summary: String, kicker: String, credit: String, hideFooter: Bool, crop: Crop) {
    headlineLabel.attributedText = NSAttributedString(
      string: headline,
      attributes: [
        .font: UIFont.boldSystemFont(ofSize: 18),
        .foregroundColor: UIColor.timesBlack
      ])

    summaryLabel.attributedText = NSAttributedString(
      string: summary,
      attributes: [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.timesGray10
      ])
    imageView.image = UIImage(named: crop.imageFilename)
    imageAspectConstraint.isActive = false
    imageAspectConstraint = imageView.heightAnchor.constraint(
      equalTo: imageView.widthAnchor,
      multiplier: crop.size.height / crop.size.width
    )
    imageAspectConstraint.isActive = true

    creditLabel.attributedText = NSAttributedString(
      string: credit,
      attributes: [
        .font: UIFont.systemFont(ofSize: 9),
        .foregroundColor: UIColor.timesGray30
      ])
    creditLabel.isHidden = credit.isEmpty

    kickerLabel.attributedText = NSAttributedString(
      string: kicker,
      attributes: [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.timesBlack
      ])
    kickerLabel.isHidden = kicker.isEmpty

    footerView.isHidden = hideFooter
  }
}
