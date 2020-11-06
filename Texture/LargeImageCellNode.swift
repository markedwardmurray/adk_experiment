//
//  LargeImageCellNode.swift
//  Sample
//
//  Created by Craig Howarth on 10/20/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

import AsyncDisplayKit
import UIKit

final class LargeImageCellNode: ASCellNode {
  var headlineNode = ASTextNode()
  var summaryNode = ASTextNode()
  var kickerNode = ASTextNode()
  var creditNode = ASTextNode()
  var imageNode = ASImageNode()
  var footerNode = FooterNode()
  var aspectRatio: CGFloat = 0.0

  private var hideFooter: Bool = false

  convenience init(headline: String, summary: String, kicker: String, credit: String, hideFooter: Bool, crop: Crop) {
    self.init()

    self.hideFooter = hideFooter

    aspectRatio = crop.size.height / crop.size.width
    imageNode.image = UIImage(named: crop.imageFilename)
    imageNode.contentMode = .scaleAspectFill

    if !credit.isEmpty {
      creditNode.attributedText = NSAttributedString(
        string: credit,
        attributes: [
          .font: UIFont.systemFont(ofSize: 9),
          .foregroundColor: UIColor.timesGray30
        ])
    }

    if !kicker.isEmpty {
      kickerNode.attributedText = NSAttributedString(
        string: kicker,
        attributes: [
          .font: UIFont.systemFont(ofSize: 12),
          .foregroundColor: UIColor.timesBlack
        ])
    }

    headlineNode.attributedText = NSAttributedString(
      string: headline,
      attributes: [
        .font: UIFont.boldSystemFont(ofSize: 18),
        .foregroundColor: UIColor.timesBlack
      ])
    
    summaryNode.attributedText = NSAttributedString(
      string: summary,
      attributes: [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.timesGray10
      ])

    addSubnode(imageNode)
    addSubnode(creditNode)
    addSubnode(kickerNode)
    addSubnode(headlineNode)
    addSubnode(summaryNode)

    if !hideFooter {
      addSubnode(footerNode)
    }
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let imageSpec = ASRatioLayoutSpec(ratio: aspectRatio, child: imageNode)
    
    let imageStackSpec = ASStackLayoutSpec.vertical()
    if creditNode.attributedText != nil {
      imageStackSpec.children = [ imageSpec, creditNode ]
    } else {
      imageStackSpec.children = [ imageSpec ]
    }
    imageStackSpec.spacing = 2.0

    let kickerHeadlineStackSpec = ASStackLayoutSpec.vertical()
    if kickerNode.attributedText != nil {
      kickerHeadlineStackSpec.children = [ kickerNode, headlineNode ]
    } else {
      kickerHeadlineStackSpec.children = [ headlineNode ]
    }
    kickerHeadlineStackSpec.spacing = 2.0

    let verticalStackSpec = ASStackLayoutSpec.vertical()
    var children: [ASLayoutElement] = [ imageStackSpec, kickerHeadlineStackSpec, summaryNode ]

    if !hideFooter {
      children.append(footerNode)
    }

    verticalStackSpec.children = children
    verticalStackSpec.spacing = 10.0
    
    let insets = UIEdgeInsets(all: 10)
    let insetSpec = ASInsetLayoutSpec(insets: insets, child: verticalStackSpec)
    
    return insetSpec
  }
}
