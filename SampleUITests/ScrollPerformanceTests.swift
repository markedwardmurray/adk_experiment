//
//  ScrollPerformanceTests.swift
//  SampleUITests
//
//  Created by Jonathan Lazar on 9/2/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import XCTest

class ScrollPerformanceTests: XCTestCase {

  override func setUpWithError() throws {
    continueAfterFailure = false
    try super.setUpWithError()
  }

  func testTextureScrollPerformance() throws {
    let app = XCUIApplication()
    app.launchArguments.append("UITests")
    app.launch()

    tapTab(named: "Texture", in: app)

    let table = app.tables.firstMatch
    XCTAssertTrue(table.exists)

    let measureOptions = XCTMeasureOptions()
    measureOptions.invocationOptions = [.manuallyStop]

    if #available(iOS 14.0, *) {
      measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric], options: measureOptions) {
        table.swipeUp(velocity: .superDuperFast)
        stopMeasuring()
        table.swipeDown(velocity: .superDuperFast)
      }
    }
  }

  func testAutoLayoutScrollPerformance() throws {
    let app = XCUIApplication()
    app.launchArguments.append("UITests")
    app.launch()
    tapTab(named: "Auto Layout", in: app)

    let table = app.collectionViews.firstMatch
    XCTAssertTrue(table.exists)

    let measureOptions = XCTMeasureOptions()
    measureOptions.invocationOptions = [.manuallyStop]

    if #available(iOS 14.0, *) {
      measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric], options: measureOptions) {
        table.swipeUp(velocity: .superDuperFast)
        stopMeasuring()
        table.swipeDown(velocity: .superDuperFast)
      }
    }
  }
}

private extension ScrollPerformanceTests {
  func tapTab(named tabName: String, in app: XCUIApplication, file: StaticString = #file, line: UInt = #line) {
    let tabBar = app.tabBars["Tab Bar"]
    XCTAssertTrue(tabBar.exists, file: file, line: line)
    let tabButton = tabBar.buttons[tabName]
    XCTAssertTrue(tabButton.exists, file: file, line: line)
    tabButton.tap()
  }

}

private extension XCUIGestureVelocity {
  static var superDuperFast: Self = 10_000
}
