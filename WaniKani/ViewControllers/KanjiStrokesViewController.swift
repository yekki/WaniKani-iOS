//
//  KanjiViewController.swift
//  WaniKani-Kanji-Strokes
//
//  Created by Andriy K. on 12/28/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import StrokeDrawingView
import DataKit

class KanjiStrokesViewController: UIViewController {
  
  let paperColor = UIColor(red:1, green:0.99, blue:0.97, alpha:1)
  
  var firstView: UIView!
  var strokeDrawingView: StrokeDrawingView!  {
    didSet {
      strokeDrawingView?.delegate = self
      if let kanji = kanji {
        strokeDrawingView?.dataSource = kanji
      }
    }
  }
  
  var showingBack = true
  
  @IBOutlet weak var container: KanjiMetaDataView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstView = UIView(frame: CGRectZero)
    firstView.backgroundColor = UIColor.redColor()
    firstView.hidden = true
    container.addSubview(firstView)
    container.backgroundColor = paperColor
    
    strokeDrawingView = StrokeDrawingView(frame: CGRectZero)
    strokeDrawingView.backgroundColor = paperColor
    
    let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapped"))
    singleTap.numberOfTapsRequired = 1
    
    container.addGestureRecognizer(singleTap)
    container.setupWithKanji(kanjiInfo)
  }
  
  override func updateUserActivityState(activity: NSUserActivity) {
    guard let userInfo = kanjiInfo?.userActivityUserInfo else { return }
    
    activity.addUserInfoEntriesFromDictionary(userInfo)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    strokeDrawingView.frame = container.bounds
    firstView.frame = container.bounds
  }
  
  func tapped() {
    if (showingBack == false) {
      UIView.transitionFromView(strokeDrawingView, toView: firstView, duration: 1, options: [UIViewAnimationOptions.TransitionFlipFromRight, .AllowAnimatedContent], completion: nil)
      showingBack = true
    } else {
      UIView.transitionFromView(firstView, toView: strokeDrawingView, duration: 1, options: [UIViewAnimationOptions.TransitionFlipFromRight, .AllowAnimatedContent], completion: nil)
      showingBack = false
    }
    
  }
  
  private var kanji: KanjiGraphicInfo? {
    didSet {
      guard let kanji = kanji else { return }
      strokeDrawingView?.stopForeverAnimation()
      strokeDrawingView?.clean()
      strokeDrawingView?.dataSource = kanji
      
    }
  }
  
  var kanjiInfo: Kanji? {
    didSet {
      if let kanjiInfo = kanjiInfo {
        container?.setupWithKanji(kanjiInfo)
        kanji = KanjiGraphicInfo(kanji: kanjiInfo.character)
        
//        let activity = kanjiInfo.userActivity
//        if #available(iOS 9.0, *) {
//          activity.eligibleForSearch = true
//        }
//        userActivity = activity
      }
    }
  }
  
}

extension KanjiStrokesViewController: StrokeDrawingViewDataDelegate {
  
  func layersAreNowReadyForAnimation() {
    self.strokeDrawingView.playForever(1.5)
  }
}


extension KanjiGraphicInfo: StrokeDrawingViewDataSource {
  func sizeOfDrawing() -> CGSize {
    return CGSize(width: 109, height: 109)
  }
  
  func numberOfStrokes() -> Int {
    return bezierPathes.count
  }
  
  func pathForIndex(index: Int) -> UIBezierPath {
    let path = bezierPathes[index]
    path.lineWidth = 3
    return path
  }
  
  func animationDurationForStroke(index: Int) -> CFTimeInterval {
    return 0.6
  }
  
  func colorForStrokeAtIndex(index: Int) -> UIColor {
    return color0
  }
  
  func colorForUnderlineStrokes() -> UIColor? {
    return UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 0.5)
  }
}