//
//  AppDelegate.swift
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    ASDisableLogging()
    if ProcessInfo.processInfo.arguments.contains("UITests") == false {
      RRFPSBar.sharedInstance().isHidden = false
    }
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = UIColor.backgroundColor
    window.rootViewController = tabBarController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }

  private let tabBarController: UITabBarController = {
    let cellCount = 1000
    let textureVc = TextureViewController(cellCount: cellCount)
    let collectionVc = CollectionViewController(cellCount: cellCount)
    let hybridCollectionVc = HybridCollectionViewController(cellCount: cellCount)

    textureVc.title = "Texture"
    collectionVc.title = "Auto Layout"
    hybridCollectionVc.title = "AL w/ Texture Cells"

    let controller = UITabBarController()
    controller.viewControllers = [textureVc,
                                  collectionVc,
                                  hybridCollectionVc
    ].map(UINavigationController.init(rootViewController:))

    textureVc.tabBarItem = UITabBarItem(title: "Texture", image: UIImage(systemName: "paintbrush"), tag: 0)
    collectionVc.tabBarItem = UITabBarItem(title: "Auto Layout", image: UIImage(systemName: "square.grid.3x2"), tag: 1)
    hybridCollectionVc.tabBarItem = UITabBarItem(title: "AL w/ Texture Cells", image: UIImage(systemName: "square.on.square.squareshape.controlhandles"), tag: 1)

    controller.selectedIndex = 0

    return controller
  }()
}
