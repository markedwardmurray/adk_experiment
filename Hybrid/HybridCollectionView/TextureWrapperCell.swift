import AsyncDisplayKit
import UIKit

final class TextureWrapperCell<Node: ASCellNode>: BottomSeparatorCell {
  // A UIView subclass that is visible on screen
  var customNode: Node? {
    didSet {
      oldValue?.view.removeFromSuperview()
      if let view = customNode?.view {
        self.contentView.addSubview(view)
        view.pinEdgesToSuperView(lowerBottomAndTrailingPriorities: true)
      }
    }
  }

  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    let sizeRange = ASSizeRange(min: CGSize(width: targetSize.width, height: 0), max: CGSize(width: targetSize.width, height: .greatestFiniteMagnitude))

    let layout = customNode?.calculateLayoutThatFits(sizeRange)

    return layout?.size ?? .zero
  }
}
