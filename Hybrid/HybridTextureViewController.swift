//
//  HybridTextureViewController.swift
//  Sample
//
//  Created by Su, Wei-Lun on 9/23/20.
//  Copyright © 2020 The New York Times. All rights reserved.
//

import UIKit
import AsyncDisplayKit

final class HybridTextureViewController: ASDKViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {
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
    // TODO: Check if we need to dequeue cells
    let headline = ContentGenerator.thisManyWords(2...8)
    let summary = ContentGenerator.thisManyWords(20...40)
    let node: ASCellNode
    switch Section(indexPath.row) {
    case .carouselSection:
      node = ScrollCellNode(numberOfItems: 10)
    case .webCellSection:
      let url = URL(string: "https://secure-ds.serving-sys.com/BurstingRes/Site-85296/WSFolders/7649898/TH029_728x90_r3.hyperesources/TH029_728x90_GiGi.jpg")!
      let cell = WebCell()
      cell.set(url: url, height: 50)
      node = BlockingUIViewNode(view: cell)

    case .largeImageCellSection:
      let cell = LargeImageCell()
      cell.set(
        headline: headline,
        summary: summary,
        kicker: "KICKER",
        credit: "Photo by Joe Blow",
        hideFooter: false,
        crop: Crop(imageFilename: "coltrane.jpg", size: CGSize(width: 540, height: 300))
      )
      node = BlockingUIViewNode(view: cell)
    case .thumbnailCellSection:
      let cell = ThumbnailCell()
      cell.set(headline: headline, summary: summary)
      node = BlockingUIViewNode(view: cell)
    case .headlineSummarySection:
      let cell = HeadlineSummaryCell()
      cell.set(headline: headline, summary: summary)
      node = BlockingUIViewNode(view: cell)
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
