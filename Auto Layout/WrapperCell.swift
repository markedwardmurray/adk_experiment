//
//  WrapperCell.swift
//  Sample
//
//  Created by Su, Wei-Lun on 9/28/20.
//  Copyright © 2020 The New York Times. All rights reserved.
//

import Foundation
import UIKit

final class WrapperCell<View: UIView>: BottomSeparatorCell {
  // A UIView subclass that is visible on screen
  let customView = View()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.insertSubview(customView, at: 0)
    customView.pinEdgesToSuperView()
  }

  override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
    return customView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
  }
}

final class SuperMegaiPadView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white

    let headline = ContentGenerator.thisManyWords(2...8)
    let summary = ContentGenerator.thisManyWords(20...40)
    let largeImageView = LargeImageView()
    let smallImageView = LargeImageView()
    let headlineSummaryView = HeadlineSummaryView()
    let thumbnailView = ThumbnailView()
    let webCell = WebView()

    // MARK: - Configure UIViews

    largeImageView.set(
      headline: headline,
      summary: summary,
      kicker: "KICKER",
      credit: "Photo by Joe Blow",
      hideFooter: false,
      crop: Crop(imageFilename: "coltrane.jpg", size: CGSize(width: 540, height: 300))
    )
    smallImageView.set(
      headline: headline,
      summary: summary,
      kicker: "",
      credit: "",
      hideFooter: true,
      crop: Crop(imageFilename: "coltrane.jpg", size: CGSize(width: 540, height: 300))
    )
    headlineSummaryView.set(headline: headline, summary: summary)
    thumbnailView.set(headline: headline, summary: summary)
    webCell.set(
      url: URL(string: "https://secure-ds.serving-sys.com/BurstingRes/Site-85296/WSFolders/7649898/TH029_728x90_r3.hyperesources/TH029_728x90_GiGi.jpg")!,
      height: 50
    )

    // MARK: - Configure StackViews

    let childStackView = UIStackView(axis: .vertical, spacing: 2, arrangedSubviews: [
      smallImageView,
      headlineSummaryView
    ])

    let secondChildStack = UIStackView(axis: .vertical, spacing: 2, arrangedSubviews: [
      largeImageView,
      headlineSummaryView
    ])

    let firstSectionStackView = UIStackView(axis: .horizontal, spacing: 2, arrangedSubviews: [
      largeImageView,
      childStackView
    ])

    firstSectionStackView.distribution = .fillEqually
    firstSectionStackView.backgroundColor = .red


    let secondSectionStackView = UIStackView(axis: .horizontal, spacing: 2, arrangedSubviews: [
      largeImageView,
      thumbnailView,
      secondChildStack
    ])

    secondSectionStackView.distribution = .fillEqually
    secondSectionStackView.backgroundColor = .blue

    let mainStack = UIStackView(axis: .vertical, spacing: 10, arrangedSubviews: [
      firstSectionStackView,
      secondSectionStackView,
      webCell,
    ])

    addSubview(mainStack)

    mainStack.pinEdgesToSuperView(lowerBottomAndTrailingPriorities: true)
    mainStack.isLayoutMarginsRelativeArrangement = true
    mainStack.layoutMargins = UIEdgeInsets(all: 10)

    NSLayoutConstraint.activate([
      //largeImageView.widthAnchor.constraint(equalToConstant: 400),
      //largeImageView.widthAnchor.constraint(equalTo: childStackView.widthAnchor, multiplier: 2),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

/*
   iPad Layout
   ------------------------------------------------------------
   |                                     |LargeImageCell      |
   |                                     | -no kicker         |
   |                                     | -no credit         |
   |                                     | -hide footer       |
   |  LargeImageCell                     |---------------------
   |                                     |HeadlineSummaryCell |
   |                                     |                    |
   ------------------------------------------------------------
   |                      |              |LargeImageCell      |
   |                      |              | -no kicker         |
   |                      |   Thumbnail  | -no credit         |
   |                      |     Cell     | -hide footer       |
   |  LargeImageCell      |              |---------------------
   |                      |              |HeadlineSummaryCell |
   |                      |              |                    |
   ------------------------------------------------------------
   |                                                          |
   |  WebCell                                                 |
   |                                                          |
   ------------------------------------------------------------
   */
