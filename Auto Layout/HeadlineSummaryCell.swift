//
//  HeadlineSummaryView.swift
//  Sample
//
//  Created by Zev Eisenberg on 9/4/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

final class HeadlineSummaryView: UIView {

  private let headlineView = UILabel().configure {
    $0.numberOfLines = 0
    $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }

  private let summaryView = UILabel().configure {
    $0.numberOfLines = 0
    $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }

  private let footerView = FooterView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    let stackView = UIStackView(arrangedSubviews: [headlineView, summaryView, footerView])
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 5
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: .inset, left: .inset, bottom: 0, right: .inset)

    addSubview(stackView)

    stackView.pinEdges(to: self, lowerBottomAndTrailingPriorities: true)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(headline: String, summary: String) {
    headlineView.attributedText = NSAttributedString(
      string: headline,
      attributes: [
        .font: UIFont.boldSystemFont(ofSize: 18),
        .foregroundColor: UIColor.black
      ]
    )

    summaryView.attributedText = NSAttributedString(
      string: summary,
      attributes: [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.darkGray
      ]
    )
  }
}
