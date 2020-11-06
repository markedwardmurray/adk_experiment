//
//  SuperMegaiPadView.swift
//  Sample
//
//  Created by Su, Wei-Lun on 9/29/20.
//  Copyright © 2020 The New York Times. All rights reserved.
//

import Foundation
import UIKit

final class SuperMegaiPadView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .timesWhite

    let headline = ContentGenerator.thisManyWords(2...8)
    let summary = ContentGenerator.thisManyWords(20...40)

    let webCell = WebView()
    webCell.set(
      url: URL(string: "https://secure-ds.serving-sys.com/BurstingRes/Site-85296/WSFolders/7649898/TH029_728x90_r3.hyperesources/TH029_728x90_GiGi.jpg")!,
      height: 50
    )

    let mainStack = UIStackView(axis: .vertical, arrangedSubviews: [
      twoColumnsStackView(headline: headline, summary: summary),
      threeColumnsStackView(headline: headline, summary: summary),
      webCell,
    ])

    addSubview(mainStack)
    mainStack.pinEdgesToSuperView(lowerBottomAndTrailingPriorities: true)
    mainStack.isLayoutMarginsRelativeArrangement = true
    mainStack.layoutMargins = UIEdgeInsets(all: 10)
  }

  private func twoColumnsStackView(headline: String, summary: String) -> UIStackView {
    let largeImageView = LargeImageView()
    let smallImageView = LargeImageView()
    let headlineSummaryView = HeadlineSummaryView()

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

    let verticalChildStackView = UIStackView(axis: .vertical, spacing: 2, arrangedSubviews: [
      smallImageView,
      headlineSummaryView
    ])

    let twoColumnsStackView = UIStackView(axis: .horizontal, spacing: 2, arrangedSubviews: [
      largeImageView,
      verticalChildStackView
    ])
    twoColumnsStackView.distribution = .fillProportionally
    return twoColumnsStackView
  }

  private func threeColumnsStackView(headline: String, summary: String) -> UIStackView {
    let largeImageView = LargeImageView()
    let smallImageView = LargeImageView()
    let headlineSummaryView = HeadlineSummaryView()
    let thumbnailView = ThumbnailView()

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

    let verticalChildStackView = UIStackView(axis: .vertical, spacing: 2, arrangedSubviews: [
      smallImageView,
      headlineSummaryView
    ])
    let threeColumnsStackView = UIStackView(axis: .horizontal, spacing: 2, arrangedSubviews: [
      largeImageView,
      thumbnailView,
      verticalChildStackView
    ])
    threeColumnsStackView.distribution = .fillEqually

    return threeColumnsStackView
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
