//
//  Section.swift
//  Sample
//
//  Created by Zev Eisenberg on 9/10/20.
//  Copyright © 2020 The New York Times. All rights reserved.
//

enum Section: CaseIterable {
  case headlineSummarySection
  case thumbnailCellSection
  case largeImageCellSection
  case webCellSection
  case carouselSection

  var isCarouselSection: Bool {
    return self == .carouselSection
  }

  init(_ sectionIndex: Int) {
    self = Self.allCases[sectionIndex % Self.allCases.count]
  }
}
