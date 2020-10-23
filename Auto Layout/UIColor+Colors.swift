//
//  UIColor+Colors.swift
//  Sample
//
//  Created by Murray, Mark on 10/23/20.
//  Copyright © 2020 The New York Times. All rights reserved.
//

import UIKit

extension UIColor {
  static var backgroundColor: UIColor {
    return UIColor { traits -> UIColor in
      switch traits.userInterfaceStyle {
      case .dark:
        return .black
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return .white
      }
    }
  }

  static var headlineText: UIColor {
    return UIColor { traits -> UIColor in
      switch traits.userInterfaceStyle {
      case .dark:
        return .white
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return .black
      }
    }
  }

  static var bodyText: UIColor {
    return UIColor { traits -> UIColor in
      switch traits.userInterfaceStyle {
      case .dark:
        return .white
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return .gray10
      }
    }
  }

  static var captionCreditText: UIColor {
    return UIColor { traits -> UIColor in
      switch traits.userInterfaceStyle {
      case .dark:
        return .gray60
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return .gray30
      }
    }
  }

  static var dateText: UIColor {
    return UIColor { traits -> UIColor in
      switch traits.userInterfaceStyle {
      case .dark:
        return .gray50
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return .gray50
      }
    }
  }

  static var disclaimerText: UIColor {
    return UIColor { traits -> UIColor in
      switch traits.userInterfaceStyle {
      case .dark:
        return .gray30
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return .gray60
      }
    }
  }

  static var dividerGrey: UIColor {
    return UIColor { traits -> UIColor in
      switch traits.userInterfaceStyle {
      case .dark:
        return .gray25
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return .gray60
      }
    }
  }

  static var statusBreaking: UIColor {
    return UIColor { traits -> UIColor in
      switch traits.userInterfaceStyle {
      case .dark:
        return .breakingRedDark
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return .breakingRedLight
      }
    }
  }

  static var statusDeveloping: UIColor {
    return UIColor { _ -> UIColor in
      return .developingOrange
    }
  }
}

// MARK: - Private Hex-Color Definitions

// swiftlint:disable force_unwrapping

private extension UIColor {
  /// A Hex-RGB color with value #000000 and alpha 1.0
  static var black = UIColor(hexString: "#000000")!

  /// A Hex-RGB color with value #121212 and alpha 1.0
  static var gray10 = UIColor(hexString: "#121212")!

  /// A Hex-RGB color with value #444444 and alpha 1.0
  static var gray25 = UIColor(hexString: "#444444")!

  /// A Hex-RGB color with value #555555 and alpha 1.0
  static var gray27 = UIColor(hexString: "#555555")!

  /// A Hex-RGB color with value #666666 and alpha 1.0
  static var gray30 = UIColor(hexString: "#666666")!

  /// A Hex-RGB color with value #999999 and alpha 1.0
  static var gray40 = UIColor(hexString: "#999999")!

  /// A Hex-RGB color with value #b3b3b3 and alpha 1.0
  static var gray45 = UIColor(hexString: "#b3b3b3")!

  /// A Hex-RGB color with value #cccccc and alpha 1.0
  static var gray50 = UIColor(hexString: "#cccccc")!

  /// A Hex-RGB color with value #e2e2e2 and alpha 1.0
  static var gray60 = UIColor(hexString: "#e2e2e2")!

  /// A Hex-RGB color with value #f7f7f7 and alpha 1.0
  static var gray90 = UIColor(hexString: "#f7f7f7")!

  /// A Hex-RGB color with value #ffffff and alpha 1.0
  static var white = UIColor(hexString: "#ffffff")!

  /// A Hex-RGB color with value #d0021b and alpha 1.0
  static var breakingRedLight = UIColor(hexString: "#d0021b")!

  /// A Hex-RGB color with value #d31e25 and alpha 1.0
  static var breakingRedDark = UIColor(hexString: "#d31e25")!

  /// A Hex-RGB color with value #f48751 and alpha 1.0
  static var developingOrange = UIColor(hexString: "#f48751")!

  /// A Hex-RGB color with value #5b8edc and alpha 1.0
  static var messagingBlue = UIColor(hexString: "#5b8edc")!

  /// A Hex-RGB color with value #a19d9d1 and alpha 1.0
  static var opinionGray = UIColor(hexString: "#a19d9d1")!
}

// swiftlint:enable force_unwrapping

// MARK: - Private Helpers

// swiftlint:disable avoid_using_default_coder_implementations

/// Converts a hex string representation of a color into integral rgba values
/// Supports length 3, 4, 6, and 8 hexadecimal values extracted out of a string
/// which can also contain any other non-hexidecimal characters. Supports upper
/// and lower case characters.
/// Examples: "369", "#369", "369f", "336699", "#336699FF"
/// - returns: the components, or `nil` if the input was invalid
private func rgba(hexString input: String) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)? {
  // remove all characters that aren't in `set` from the input
  let set = CharacterSet(charactersIn: "0123456789ABCDEF")
  var hexString = input.uppercased().components(separatedBy: set.inverted).joined()

  // normalize `hexString` to "RRGGBBAA" format
  switch hexString.count {
  case 3: // "RGB"
    hexString = String(hexString.flatMap { String(repeating: $0, count: 2) }) + "FF"
  case 4: // "RGBA"
    hexString = String(hexString.flatMap { String(repeating: $0, count: 2) })
  case 6: // "RRGGBB"
    hexString += "FF"
  case 8: // "RRGGBBAA"
    break
  default:
    return nil
  }
  var scanned: UInt64 = 0
  guard Scanner(string: hexString).scanHexInt64(&scanned) else {
    assert(false, "Unexpected failure. The input was supposed to be sanitized and normalized to an 8 character string of hexidecimal characters") // swiftlint:disable:this direct_assert_calls explicit_failure_calls
    return nil
  }
  return rgba(scanned)
}

private func rgba(_ color: UInt64) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
  let red = UInt8((color & 0xFF00_0000) >> 24)
  let green = UInt8((color & 0x00FF_0000) >> 16)
  let blue = UInt8((color & 0x0000_FF00) >> 8)
  let alpha = UInt8(color & 0x0000_00FF)
  return (red, green, blue, alpha)
}

#if !canImport(UIKit)
/// Note: create initializers and API as needed to mirror the `UIColor` API used by the app
open class UIColor: NSObject, NSCoding {
  public let red: CGFloat
  public let green: CGFloat
  public let blue: CGFloat
  public let alpha: CGFloat

  public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }

  private enum Keys: String {
    case red, green, blue, alpha
  }

  public required init?(coder aDecoder: NSCoder) {
    red = aDecoder.decodeDouble(forKey: Keys.red.rawValue)
    green = aDecoder.decodeDouble(forKey: Keys.green.rawValue)
    blue = aDecoder.decodeDouble(forKey: Keys.blue.rawValue)
    alpha = aDecoder.decodeDouble(forKey: Keys.alpha.rawValue)
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(red, forKey: Keys.red.rawValue)
    aCoder.encode(green, forKey: Keys.green.rawValue)
    aCoder.encode(blue, forKey: Keys.blue.rawValue)
    aCoder.encode(alpha, forKey: Keys.alpha.rawValue)
  }

  override public func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? UIColor else {
      return false
    }
    return red == other.red
      && green == other.green
      && blue == other.blue
      && alpha == other.alpha
  }

  public static let black: UIColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
  public static let white: UIColor = .init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}
#endif

private extension UIColor {
  convenience init?(hexString input: String) {
    guard let (r, g, b, a) = rgba(hexString: input) else {
      return nil
    }
    self.init(
      red: CGFloat(r) / 255.0,
      green: CGFloat(g) / 255.0,
      blue: CGFloat(b) / 255.0,
      alpha: CGFloat(a) / 255.0
    )
  }
}

