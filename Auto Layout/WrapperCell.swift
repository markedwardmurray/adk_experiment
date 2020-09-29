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
