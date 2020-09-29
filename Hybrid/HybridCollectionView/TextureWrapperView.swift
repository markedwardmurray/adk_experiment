//
//  TextureWrapperView.swift
//  Sample
//
//  Created by Su, Wei-Lun on 9/28/20.
//  Copyright © 2020 The New York Times. All rights reserved.
//

import Foundation
import UIKit

final class WrapperCell<View: UIView>: BottomSeparatorCell {
  // A UIView subclass that is visible on screen
  var customView: View? {
    didSet {
      oldValue?.removeFromSuperview()
      if let view = customView {
        self.contentView.addSubview(view)
        view.pinEdgesToSuperView(lowerBottomAndTrailingPriorities: true)
      }
    }
  }
}
