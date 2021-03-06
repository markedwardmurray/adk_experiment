//
//  LayoutPerformanceTimeTests.swift
//  SampleTests
//
//  Created by Jonathan Lazar on 9/2/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

@testable import Sample
import XCTest

class LayoutPerformanceTimeTests: XCTestCase {

  func testTexturePerformance() throws {
    let vc = TextureViewController(cellCount: 1000)
    measureMetrics([.wallClockTime], automaticallyStartMeasuring: false, for: {
      startMeasuring()
      vc.view.layoutIfNeeded()
      stopMeasuring()
    })
  }

  func testCollectionViewPerformance() throws {
    let vc = CollectionViewController(cellCount: 1000)
    measureMetrics([.wallClockTime], automaticallyStartMeasuring: false, for: {
      startMeasuring()
      vc.view.layoutIfNeeded()
      stopMeasuring()
    })
  }
}
