//
//  WebCellNode.swift
//  Sample
//
//  Created by Craig Howarth on 10/30/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

import AsyncDisplayKit
import UIKit
import WebKit

final class WebCellNode: ASCellNode {
  var disclaimerNode = ASTextNode()
  var webNode = ASDisplayNode()
  var webView: WKWebView?
  var url: URL?
  var height: CGFloat = 0
  
  convenience init(url: URL, height: CGFloat) {
    self.init()
    self.url = url
    self.height = height
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    disclaimerNode.attributedText = NSAttributedString(
      string: "ADVERTISEMENT",
      attributes: [
        .font: UIFont.systemFont(ofSize: 9.0),
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor.timesGray60
      ])
    
    addSubnode(disclaimerNode)
    addSubnode(webNode)
  }
  
  override func didLoad() {
    super.didLoad()
    webView = WKWebView(frame: webNode.bounds)
    webView?.scrollView.isScrollEnabled = false
    if let webView = webView, let url = url {
      webView.load(NSURLRequest(url: url as URL) as URLRequest)
      webNode.view.addSubview(webView)
    }
  }
  
  override func layout() {
    super.layout()
    webView?.frame = webNode.bounds
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let nodeMargin: CGFloat = 10.0
    let insetWidth = constrainedSize.max.width - (nodeMargin * 2.0)
    webNode.bounds = CGRect(x: 0, y: 0, width: insetWidth, height: height)
    webNode.style.preferredSize = CGSize(width: insetWidth, height: height)

    let verticalStackSpec = ASStackLayoutSpec.vertical()
    verticalStackSpec.children = [ disclaimerNode, webNode ]
    verticalStackSpec.spacing = 10.0
    
    let insets = UIEdgeInsets(all: nodeMargin)
    return ASInsetLayoutSpec(insets: insets, child: verticalStackSpec)
  }
}
