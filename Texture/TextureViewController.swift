//
//  ViewController.swift
//  Sample
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit
import AsyncDisplayKit

final class TextureViewController: ASDKViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {
  struct State {
    var itemCount: Int
    var fetchingMore: Bool
    static let empty = State(itemCount: 20, fetchingMore: false)
  }

  var tableNode: ASTableNode {
    return node as! ASTableNode
  }

  private let cellCount: Int
  private(set) var state: State = .empty

  init(cellCount: Int) {
    self.cellCount = cellCount
    super.init(node: ASTableNode())
    tableNode.delegate = self
    tableNode.dataSource = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }

  private override init() {
    fatalError("init() is not supported. use init(data:) instead.")
  }

  // MARK: ASTableView data source and delegate.

  func tableView(_ tableView: ASTableView, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
    let headline = ContentGenerator.thisManyWords(2...8)
    let summary = ContentGenerator.thisManyWords(20...40)
    let node: ASCellNode
    switch Section(indexPath.row) {
    case .carouselSection:
      node = ScrollCellNode(numberOfItems: 10)
    case .webCellSection:
      let url = NSURL(string: "https://secure-ds.serving-sys.com/BurstingRes/Site-85296/WSFolders/7649898/TH029_728x90_r3.hyperesources/TH029_728x90_GiGi.jpg")!
      node = WebCellNode(url: url, height: 50)
    case .largeImageCellSection:
      let crop = Crop(imageFilename: "coltrane.jpg", size: CGSize(width: 540, height: 300))
      node = LargeImageCellNode(
        headline: headline,
          summary: summary,
          kicker: "KICKER",
          credit: "Photo by Joe Blow",
          hideFooter: false,
          crop: crop
      )
    case .thumbnailCellSection:
      node = ThumbnailCellNode(headline: headline, summary: summary)
    case .headlineSummarySection:
      //node = HeadlineSummaryCellNode(headline: headline, summary: summary)
      let cell = HeadlineSummaryCell()
      cell.set(headline: headline, summary: summary)
      cell.backgroundColor = .red

      let prototypeCell = HeadlineSummaryCell()
      prototypeCell.set(headline: headline, summary: summary)
      prototypeCell.backgroundColor = .blue

      node = BackgroundSafeProtoTypeNode(view: cell, prototypeView: prototypeCell)
    }

    node.selectionStyle = UITableViewCell.SelectionStyle.none

    return node
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellCount
  }
}

final class BlockingUIViewNode: ASCellNode {
  private let customView: UIView

  init(view: UIView) {
    self.customView = view
    super.init()
    self.setViewBlock { [weak self] () -> UIView in
      return self?.customView ?? UIView()
    }
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let targetSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.min.height)

    dispatchPrecondition(condition: .notOnQueue(.main))

    return DispatchQueue.main.sync {
      let size = self.customView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
      let layoutSpec = ASLayoutSpec()

      layoutSpec.style.preferredSize = size
      return layoutSpec
    }
  }
}

final class BackgroundSafeProtoTypeNode: ASCellNode {
  // A UIView subclass that is visible on screen
  private let customView: UIView
  // A UIView subclass that is for measurement only
  private let prototypeView: UIView

  init(view: UIView, prototypeView: UIView) {
    self.customView = view
    self.prototypeView = prototypeView
    super.init()
    assert(self.customView != self.prototypeView)

    self.setViewBlock { [weak self] () -> UIView in
      return self?.customView ?? UIView()
    }
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let targetSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.min.height)
    let size = self.prototypeView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    let layoutSpec = ASLayoutSpec()

    layoutSpec.style.preferredSize = size
    return layoutSpec
  }
}
